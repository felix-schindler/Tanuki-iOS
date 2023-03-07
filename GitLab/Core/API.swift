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
    @AppStorage("domain") public static var domain: String = "gitlab.com"
    @AppStorage("api_base") public static var base: String = "api/v4"
    @AppStorage("token") public static var token: String = ""
    
    private static let client: HttpClient = UrlSessionHttpClient(log: false)
    private static let decoder = JSONDecoder()
    
    public static func req<T: Codable>(type: T.Type, method: HttpMethod, endpoint: String, query: Dictionary<String, String> = [:], body: Dictionary<String, String> = [:]) async -> T? {
        let httpUrl = HttpUrl(host: domain, path: [base, endpoint], query: query, trailingSlashEnabled: false)
        do {
            var reqBody: Data? = nil
            if (!body.isEmpty) {
                reqBody = try JSONEncoder().encode(body)
            }
        
            let req = HttpRawRequest(url: httpUrl,
                                     method: method,
                                     headers: [
                                        .authorization: "Bearer \(token)",
                                        .contentType: "application/json"
                                     ],
                                     body: reqBody)
        
            print(method, httpUrl.url.absoluteString)
            let response = try await client.dataTask(req)

            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .custom(iso8601Decoder())    // FIXME: this may introduce data races

            return try decoder.decode(T.self, from: response.data)
        } catch let DecodingError.dataCorrupted(context) {
            print("dataCorrupted", context)
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
            print("error: ", error)
        }
        return nil
    }
    
    public static func get<T: Codable>(type: T.Type, endpoint: String, query: Dictionary<String, String> = [:]) async -> T? {
        return await API.req(type: type, method: .get, endpoint: endpoint, query: query)
    }
}
