//
//  API.swift
//  Tanuki (GitLab)
//
//  Created by Felix Schindler on 30.10.21.
//  Rewritten by Felix Schindler on 07.03.24.
//

import Alamofire
import Foundation
import SwiftUI

#if canImport(WatchConnectivity)
	import WatchConnectivity
#endif

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
		let oldHost =
			legacyStore?.string(forKey: legacyHostKey)
			?? userDefaults.string(forKey: legacyHostKey)
			?? "gitlab.com"
		let oldToken =
			legacyStore?.string(forKey: legacyTokenKey)
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
			"instances": data
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

	private static let encoder = JSONEncoder()
	private static let decoder = JSONDecoder()
	private static let session: Session = .default

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
		URL(string: "https://\(host)")!
	}

	public static var graphUrl: URL {
		URL(string: "https://\(host)/api/graphql")!
	}

	/// This is only `public` because it's used by `FileLoader` and `FeedbackView`
	public static func raw(
		method: HTTPMethod,
		endpoint: String,
		resource: String? = nil,
		suffix: String? = nil,
		query: [String: String] = [:],
		body: (any Encodable)? = nil,
		contentType: ContentType = .json,
		auth: Bool = true,
		useBase: Bool = true,
		host: String? = nil
	) async throws -> AFDataResponse<Data> {
		let targetHost = host ?? API.host

		var path = useBase ? [base, endpoint] : [endpoint]
		if let resource {
			path.append(resource)
		}
		if let suffix {
			path.append(suffix)
		}

		let url = "https://\(targetHost)/" + path.joined(separator: "/")

		var headers: HTTPHeaders = [.contentType(contentType.rawValue)]
		if auth && token.isNotEmpty {
			headers.add(.authorization(bearerToken: token))
		}

		var parameters: Parameters?
		if let body {
			parameters = try JSONSerialization.jsonObject(with: encoder.encode(body)) as? Parameters
		}

		let encoding: ParameterEncoding =
			(contentType == .json) ? JSONEncoding.default : URLEncoding.default

		return await session.request(
			url,
			method: method,
			parameters: parameters,
			encoding: encoding,
			headers: headers
		).serializingData().response
	}

	public static func req<T: Codable>(
		type: T.Type,
		method: HTTPMethod,
		endpoint: String,
		resource: String? = nil,
		suffix: String? = nil,
		query: [String: String] = [:],
		body: (any Encodable)? = nil,
		contentType: ContentType = .json,
		useBase: Bool = true
	) async throws -> T {
		let response = try await API.raw(
			method: method,
			endpoint: endpoint,
			resource: resource,
			suffix: suffix,
			query: query,
			body: body,
			contentType: contentType,
			auth: true,
			useBase: useBase
		)

		guard let data = response.data else {
			throw AFError.responseValidationFailed(reason: .dataFileNil)
		}

		decoder.keyDecodingStrategy = .convertFromSnakeCase

		decoder.dateDecodingStrategy = .custom({ decoder -> Date in
			let formatter = ISO8601DateFormatter()
			formatter.formatOptions = [
				.withInternetDateTime, .withFractionalSeconds,
			]

			let dateStr = try decoder.singleValueContainer().decode(String.self)

			if let date = formatter.date(from: dateStr) {
				return date
			}

			throw DateError.invalidDate
		})

		return try decoder.decode(T.self, from: data)
	}

	public static func get<T: Codable>(
		type: T.Type,
		endpoint: String,
		query: [String: String] = [:],
		useBase: Bool = true
	) async throws -> T {
		try await API.req(
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
			endpoint: endpoint,
			query: query,
			auth: true
		)
	}
}
