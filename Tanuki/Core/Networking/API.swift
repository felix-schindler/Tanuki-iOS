//
//  API.swift
//  Tanuki (GitLab)
//
//  Created by Felix Schindler on 30.10.21.
//  Rewritten by Felix Schindler on 07.03.24.
//

import Foundation
#if canImport(WatchConnectivity)
import WatchConnectivity
#endif
@preconcurrency import SwiftHttp
import SwiftUI

enum DateError: String, Error {
	case invalidDate
}

enum ContentType: String {
	case json = "application/json"
	case formUrlEncoded = "application/x-www-form-urlencoded"
}

struct GitLabInstance: Codable, Identifiable, Equatable {
	var id: String { host }
	let host: String
	let token: String
	let isOAuth: Bool

	init(host: String, token: String, isOAuth: Bool = false) {
		self.host = host
		self.token = token
		self.isOAuth = isOAuth
	}
}

@MainActor
class InstanceManager {
	private static let userDefaults = UserDefaults(suiteName: "group.de.schindlerfelix.GitLab")!
	private static let legacyUserDefaults = UserDefaults(suiteName: "de.schindlerfelix.GitLab")
	private static let instancesKey = "instances"
	private static let selectedKey = "selectedInstance"
	private static let legacyHostKey = "domain"
	private static let legacyTokenKey = "token"
	private static let migrationDoneKey = "migration_done"

	static var instances: [GitLabInstance] {
		get {
			guard let data = userDefaults.data(forKey: instancesKey),
				  let instances = try? JSONDecoder().decode([GitLabInstance].self, from: data)
			else {
				return []
			}
			return instances
		}
		set {
			if let data = try? JSONEncoder().encode(newValue) {
				userDefaults.set(data, forKey: instancesKey)
			}
		}
	}

	static var selectedId: String? {
		get {
			userDefaults.string(forKey: selectedKey)
		}
		set {
			userDefaults.set(newValue, forKey: selectedKey)
		}
	}

	static var selected: GitLabInstance? {
		guard let id = selectedId else { return nil }
		return instances.first { $0.id == id }
	}

	static func migrate() {
		guard !userDefaults.bool(forKey: migrationDoneKey) else { return }

		let legacyStore = legacyUserDefaults
		let oldHost = legacyStore?.string(forKey: legacyHostKey)
			?? userDefaults.string(forKey: legacyHostKey)
			?? "gitlab.com"
		let oldToken = legacyStore?.string(forKey: legacyTokenKey)
			?? userDefaults.string(forKey: legacyTokenKey)
			?? ""

		guard oldHost.isNotEmpty || oldToken.isNotEmpty else {
			userDefaults.set(true, forKey: migrationDoneKey)
			return
		}

		let instance = GitLabInstance(
			host: oldHost,
			token: oldToken,
			isOAuth: oldHost == "gitlab.com" && oldToken.isNotEmpty
		)
		add(instance)

		userDefaults.removeObject(forKey: legacyHostKey)
		userDefaults.removeObject(forKey: legacyTokenKey)
		legacyStore?.removeObject(forKey: legacyHostKey)
		legacyStore?.removeObject(forKey: legacyTokenKey)
		userDefaults.set(true, forKey: migrationDoneKey)
		WatchSync.shared.pushInstances()
	}

	static func add(_ instance: GitLabInstance) {
		var current = instances
		current.removeAll { $0.id == instance.id }
		current.append(instance)
		instances = current
		selectedId = instance.id
		WatchSync.shared.pushInstances()
	}

	static func remove(_ instance: GitLabInstance) {
		var current = instances
		current.removeAll { $0.id == instance.id }
		instances = current

		if selectedId == instance.id {
			selectedId = current.last?.id
		}
		WatchSync.shared.pushInstances()
	}

	static func select(_ instance: GitLabInstance) {
		selectedId = instance.id
		WatchSync.shared.pushInstances()
	}

	static func update(_ instance: GitLabInstance) {
		remove(instance)
		add(instance)
		WatchSync.shared.pushInstances()
	}
}

@MainActor
final class WatchSync: NSObject, WCSessionDelegate {
	static let shared = WatchSync()
	private let encoder = JSONEncoder()
	private var didActivate = false

	func activate() {
		guard WCSession.isSupported() else { return }
		let session = WCSession.default
		session.delegate = self
		session.activate()
	}

	func pushInstances() {
		guard WCSession.isSupported() else { return }
		let session = WCSession.default
		if !didActivate {
			activate()
		}

		guard let data = try? encoder.encode(InstanceManager.instances) else { return }
		var context: [String: Any] = [
			"instances": data,
		]
		if let selectedId = InstanceManager.selectedId {
			context["selectedId"] = selectedId
		}

		try? session.updateApplicationContext(context)
	}

	nonisolated func session(
		_ session: WCSession,
		activationDidCompleteWith activationState: WCSessionActivationState,
		error: Error?
	) {
		Task { @MainActor in
			didActivate = activationState == .activated
			if didActivate {
				pushInstances()
			}
		}
	}

	nonisolated func sessionDidBecomeInactive(_ session: WCSession) {}

	nonisolated func sessionDidDeactivate(_ session: WCSession) {
		session.activate()
	}
}

@MainActor
class API {
	/// API endpoint (including version)
	public static var base: String = "api/v4"

	private nonisolated(unsafe) static let client: HttpClient = UrlSessionHttpClient(
		session: .shared,
		logLevel: .critical
	)
	private static let encoder = JSONEncoder()
	private static let decoder = JSONDecoder()

	public static var host: String {
		get {
			InstanceManager.selected?.host ?? "gitlab.com"
		}
		set {
			var instance = InstanceManager.selected ?? GitLabInstance(host: "gitlab.com", token: "")
			instance = GitLabInstance(host: newValue, token: instance.token, isOAuth: instance.isOAuth)
			InstanceManager.add(instance)
		}
	}

	public static var token: String {
		get {
			InstanceManager.selected?.token ?? ""
		}
		set {
			var instance = InstanceManager.selected ?? GitLabInstance(host: "gitlab.com", token: "")
			instance = GitLabInstance(host: instance.host, token: newValue, isOAuth: instance.isOAuth)
			InstanceManager.add(instance)
		}
	}

	public static var isOAuth: Bool {
		InstanceManager.selected?.isOAuth ?? false
	}

	public static var currentInstance: GitLabInstance? {
		InstanceManager.selected
	}

	public static var url: URL {
		return URL(string: "https://\(host)")!
	}

	public static var graphUrl: URL {
		return URL(string: "https://\(host)/api/graphql")!
	}

	/// This is only `public` because it's used by `FileLoader` and `FeedbackView`
	public static func raw(
		method: HttpMethod,
		url: HttpUrl,
		body: (any Encodable)? = nil,
		contentType: ContentType = .json,
		auth: Bool = true
	) async throws -> HttpResponse {
		var headers: [HttpHeaderKey: String] = [:]
		var reqBody: Data? = nil

		print(method, url.url.absoluteString)

		if let body {
			headers[.contentType] = contentType.rawValue

			switch contentType {
			case .json:
				reqBody = try encoder.encode(body)
				break
			case .formUrlEncoded:
				reqBody = try FormURLEncoder.encode(body)
				break
			}

			print(String(data: reqBody!, encoding: .utf8) ?? "Body coudn't be decoded")
		}

		if auth && API.token.isNotEmpty {
			headers[.authorization] = "Bearer \(API.token)"
		}

		let req = HttpRawRequest(
			url: url,
			method: method,
			headers: headers,
			body: reqBody
		)

		return try await client.dataTask(req)
	}

	public static func req<T: Codable>(
		type: T.Type,
		method: HttpMethod,
		endpoint: String,
		resource: String? = nil,
		suffix: String? = nil,
		query: [String: String] = [:],
		body: (any Encodable)? = nil,
		contentType: ContentType = .json,
		useBase: Bool = true
	) async throws -> T {
		let httpUrl = HttpUrl(
			host: host,
			path: useBase ? [base, endpoint] : [endpoint],
			resource: resource,
			suffix: suffix,
			query: query
		)

		let res = try await API.raw(
			method: method,
			url: httpUrl,
			body: body,
			contentType: contentType
		)

		print(res.statusCode)

		decoder.keyDecodingStrategy = .convertFromSnakeCase

		decoder.dateDecodingStrategy = .custom({ decoder -> Date in
			let formatter = ISO8601DateFormatter()
			formatter.formatOptions = [
				.withInternetDateTime, .withFractionalSeconds,
			]

			let dateStr = try decoder.singleValueContainer().decode(
				String.self)

			if let date = formatter.date(from: dateStr) {
				return date
			}

			throw DateError.invalidDate
		})

		return try decoder.decode(T.self, from: res.data)
	}

	public static func get<T: Codable>(
		type: T.Type,
		endpoint: String,
		query: [String: String] = [:],
		useBase: Bool = true
	) async throws -> T {
		return try await API.req(
			type: type,
			method: .get,
			endpoint: endpoint,
			query: query,
			useBase: useBase
		)
	}

	public static func delete(
		endpoint: String,
		query: [String: String] = [:]
	) async throws {
		_ = try await API.raw(
			method: .delete,
			url: HttpUrl(
				host: host,
				path: [base, endpoint],
				query: query
			)
		)
	}
}
