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

enum ContentType: String {
	case json = "application/json"
	case formUrlEncoded = "application/x-www-form-urlencoded"
}

enum DateError: Error {
	case invalidDate
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
