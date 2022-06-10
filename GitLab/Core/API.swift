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
    @AppStorage("domain") public static var domain: String = ""
    @AppStorage("api_base") public static var base: String = "api/v4"
    @AppStorage("token") public static var token: String = ""
    
    private static let client: HttpClient = UrlSessionHttpClient(log: false)
    private static let decoder = JSONDecoder()
    
    public static func get<T: Codable>(type: T.Type, endpoint: String, query: Dictionary<String, String>? = [:]) async -> T? {
        let url = HttpUrl(host: domain.replacingOccurrences(of: "https://", with: ""), path: [base, endpoint], query: [:])

        let req = HttpRawRequest(url: url,
                                 method: .get,
                                 headers: [
                                    .key(.authorization): "Bearer \(token)"
                                 ],
                                 body: nil)

        do {
            let response = try await client.dataTask(req)
            
            print("URL: \(req.urlRequest.curlString)")
            print(String(decoding: response.data, as: UTF8.self))

            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .custom(iso8601Decoder())

            return try decoder.decode(T.self, from: response.data)
        } catch {
            print(error)
            return nil
        }
    }
    
    /**
     Make a POST request to an API endpoint

     - Parameter endpoint: API endpoint (/api/:endpoint)
     - Parameter values: Hashmap with values to be send as POST values
     - Returns: Data to be decoded as e. g. JSON or nil if no connection
     */
    public static func POST(endpoint: String, values: Dictionary<String,String>? = nil) -> Data? {
        // No internet connection or link does not exist
        let url: URL? = URL(string: domain + "/" + base + "/" + endpoint)
        if (url == nil) {
            return nil
        }

        // Initialize variables
        var apiData: Data? = nil
        let semaphore = DispatchSemaphore(value: 0)

        // Build post data string
        var dataStr: String = ""
        if (values != nil) {
            for (k,v) in values! {   // Key and value
                if (dataStr == "") {
                    dataStr += "{"
                }
                dataStr += "\(String(k).url()): \(String(v).url())"
            }
            dataStr += "}"
            print("[API.POST] DEBUG: " + dataStr)
        }

        // POST-Request with data
        var request: URLRequest = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type");
            request.httpBody = dataStr.data(using: .utf8)!

        // Session config with auth header and token, when required
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = ["PRIVATE-TOKEN": token]

        // Send the request
        URLSession(configuration: sessionConfig).dataTask(with: request, completionHandler: { (data, res, _) in
            apiData = data
            semaphore.signal()
        }).resume()

        // Wait for the signal (finished API request)
        _ = semaphore.wait(wallTimeout: .distantFuture)
        return apiData
    }
    
    public static func PUT(endpoint: String) -> Data? {
        // No internet connection or link does not exist
        let url: URL? = URL(string: domain + "/" + base + "/" + endpoint)
        if (url == nil) {
            return nil
        }

        var apiData: Data? = nil
        let semaphore = DispatchSemaphore(value: 0)

        var request: URLRequest = URLRequest(url: url!)
            request.httpMethod = "PUT"

        // Session config with auth header and token, when required
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = ["PRIVATE-TOKEN": token]

        // Send the request
        URLSession(configuration: sessionConfig).dataTask(with: request, completionHandler: { (data, _, _) in
            apiData = data
            semaphore.signal()
        }).resume()

        // Wait for the signal (finished API request)
        _ = semaphore.wait(wallTimeout: .distantFuture)
        return apiData
    }
}
