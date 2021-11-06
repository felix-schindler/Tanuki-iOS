//
//  API.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import Foundation
import SwiftUI

class API {
    @AppStorage("api_base") public static var base: String = ""
    @AppStorage("token") public static var token: String = ""

    /**
     Make a GET request to an API endpoint

     - Parameter endpoint: API endpoint (/api/:endpoint)
     - Returns: Data to be decoded as e. g. JSON
     */
    public static func GET(endpoint: String) -> Data? {
        // No internet connection or link does not exist
        let url: URL? = URL(string: API.base + endpoint);
        if (url == nil) {
            return nil
        }

        // Initialize variables
        var apiData: Data? = nil
        let semaphore = DispatchSemaphore(value: 0)

        // Session config with auth header and token, when required
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = ["PRIVATE-TOKEN": token]

        // Send the request
        URLSession(configuration: sessionConfig).dataTask(with: URLRequest(url: url!), completionHandler: { (data, _, _) in
            apiData = data
            semaphore.signal()
        }).resume()

        // Wait for the signal (finished API request)
        _ = semaphore.wait(wallTimeout: .distantFuture)
        return apiData
    }

    /**
     Make a POST request to an API endpoint

     - Parameter endpoint: API endpoint (/api/:endpoint)
     - Parameter values: Hashmap with values to be send as POST values
     - Returns: Data to be decoded as e. g. JSON or nil if no connection
     */
    public static func POST(endpoint: String, values: Dictionary<String,String>? = nil) -> Data? {
        // No internet connection or link does not exist
        let url: URL? = URL(string: API.base + endpoint);
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
                if (dataStr != "") {
                    dataStr += "&"
                }
                dataStr += "\(String(describing: k.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))=\(String(describing: v.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))"
            }
        }

        // POST-Request with data
        var request: URLRequest = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type");
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
        let url: URL? = URL(string: API.base + endpoint);
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
