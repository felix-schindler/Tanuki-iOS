//
//  API.swift
//  Tanuki (GitLab)
//
//  Created by Felix Schindler on 30.10.21.
//  Rewritten by Felix Schindler on 07.03.24.
//

import Foundation
@preconcurrency import SwiftHttp
import SwiftUI

enum DateError: String, Error {
	case invalidDate
}

enum ContentType: String {
	case json = "application/json"
	case formUrlEncoded = "application/x-www-form-urlencoded"
}

@MainActor
class API {
	/// GitLab host
	@AppStorage("domain", store: UserDefaults(suiteName: "de.schindlerfelix.GitLab"))
	public static var host: String = "gitlab.com"

	/// GitLab token
	@AppStorage("token", store: UserDefaults(suiteName: "de.schindlerfelix.GitLab"))
	public static var token: String = ""

	/// API endpoint (including version)
	public static var base: String = "api/v4"

	private nonisolated(unsafe) static let client: HttpClient = UrlSessionHttpClient(
		session: .shared,
		logLevel: .critical
	)
	private static let encoder = JSONEncoder()
	private static let decoder = JSONDecoder()

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
