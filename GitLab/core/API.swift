//
//  API.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import Foundation
import SwiftUI
import SwiftHttp

class API {
	/// GitLab host
	@AppStorage("domain")
	public static var domain: String = "gitlab.com"
	
	/// API endpoint (including version)
	@AppStorage("api_base")
	public static var base: String = "api/v4"
	
	/// Bearer token - normally a personal access token
	@AppStorage("token")
	public static var token: String = ""
	
	private static let client: HttpClient = UrlSessionHttpClient(log: false)
	private static let decoder = JSONDecoder()
	
	private static func raw(
		method: HttpMethod,
		url: HttpUrl,
		body: Dictionary<String, String> = [:]
	) async throws -> HttpResponse {
		var reqBody: Data? = nil
		if (!body.isEmpty) {
			reqBody = try JSONEncoder().encode(body)
		}
		
		let req = HttpRawRequest(url: url,
														 method: method,
														 headers: [
															.authorization: "Bearer \(token)",
															.contentType: "application/json"
														 ],
														 body: reqBody)
		
		print(method, url.url.absoluteString)
		return try await client.dataTask(req)
	}
	
	public static func req<T: Codable>(
		type: T.Type,
		method: HttpMethod,
		endpoint: String,
		resource: String? = nil,
		query: Dictionary<String, String> = [:],
		body: Dictionary<String, String> = [:],
		useBase: Bool = true
	) async -> T? {
		var httpUrl = HttpUrl(
			host: domain,
			resource: resource,
			query: query,
			trailingSlashEnabled: false
		)

		if (useBase) {
			httpUrl = httpUrl.path([base, endpoint])
		} else {
			httpUrl = httpUrl.path([endpoint])
		}
		
		do {
			let res = try await API.raw(
				method: method,
				url: httpUrl,
				body: body
			)
			
			decoder.keyDecodingStrategy = .convertFromSnakeCase
			decoder.dateDecodingStrategy = .custom(iso8601Decoder())    // FIXME: this may introduce data
			
			// print("\(res.statusCode): \(res.utf8String ?? "")")
			return try decoder.decode(T.self, from: res.data)
		} catch let DecodingError.dataCorrupted(context) {
			print("Data corrupted: ", context.debugDescription)
			print("codingPath:", context.codingPath)
		} catch let DecodingError.keyNotFound(key, context) {
			print("Key '\(key)' not found:", context.debugDescription)
			print("codingPath:", context.codingPath)
		} catch let DecodingError.valueNotFound(value, context) {
			print("Value '\(value)' not found:", context.debugDescription)
			print("codingPath:", context.codingPath)
		} catch let DecodingError.typeMismatch(type, context)  {
			print("Type '\(type)' mismatch:", context.debugDescription)
			print("codingPath:", context.codingPath)
		} catch {
			print("Error: ", error)
		}
		
		return nil
	}
	
	public static func get<T: Codable>(
		type: T.Type,
		endpoint: String,
		query: Dictionary<String, String> = [:],
		useBase: Bool = true
	) async -> T? {
		return await API.req(
			type: type,
			method: .get,
			endpoint: endpoint,
			query: query,
			useBase: useBase
		)
	}
	
	public static func delete(
		endpoint: String,
		query: Dictionary<String, String> = [:]
	) async -> HttpStatusCode {
		do {
			return try await API.raw(
				method: .delete,
				url: HttpUrl(
					host: domain,
					path: [base, endpoint],
					query: query,
					trailingSlashEnabled: false
				)
			).statusCode
		} catch {
			print("Error", error)
		}
		
		return HttpStatusCode.internalServerError
	}
}
