//
//  Network.swift
//  Tanuki
//
//  Created by Felix Schindler on 26.02.24.
//

import SwiftUI
import Apollo
import ApolloAPI
import ApolloSQLite

class API {
	/// GitLab host
	@AppStorage("domain")
	public static var domain: String = "gitlab.com"
	
	/// Bearer token - normally a personal access token
	@AppStorage("token")
	public static var token: String = "glpat-YXDgEER3pP5esynN4sHa"
	
	public static var url: URL {
		return URL(string: "https://\(self.domain)/api/graphql")!
	}
}

class Network {
	static let shared = Network()
	
	private(set) lazy var apollo: ApolloClient = {
		var store: ApolloStore
		
		do {
			let documentsPath = NSSearchPathForDirectoriesInDomains(
				.documentDirectory,
				.userDomainMask,
				true
			).first!
			let documentsURL = URL(fileURLWithPath: documentsPath)
			let sqliteFileURL = documentsURL.appendingPathComponent("tanuki_apollo_cache_db.sqlite")
			
			let sqliteCache = try SQLiteNormalizedCache(fileURL: sqliteFileURL)
			store = ApolloStore(cache: sqliteCache)
			
			print("Using SQLite cache")
		} catch {
			print("SQLite cache init failed; Using in-memory cache")
			let cache = InMemoryNormalizedCache()
			store = ApolloStore(cache: cache)
		}
		
		let client = URLSessionClient()
		let provider = NetworkInterceptorProvider(client: client, store: store)
		let url = API.url
		let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: url)
		
		return ApolloClient(networkTransport: transport, store: store)
	}()
}

class AuthorizationInterceptor: ApolloInterceptor {
	public var id: String = UUID().uuidString
	
	func interceptAsync<Operation>(
		chain: RequestChain,
		request: HTTPRequest<Operation>,
		response: HTTPResponse<Operation>?,
		completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
	) where Operation : GraphQLOperation {
		request.addHeader(name: "Authorization", value: "Bearer \(API.token)")
		
		chain.proceedAsync(
			request: request,
			response: response,
			interceptor: self,
			completion: completion
		)
	}
}

class NetworkInterceptorProvider: DefaultInterceptorProvider {
	
	override func interceptors<Operation>(for operation: Operation) -> [ApolloInterceptor] where Operation : GraphQLOperation {
		var interceptors = super.interceptors(for: operation)
		interceptors.insert(AuthorizationInterceptor(), at: 0)
		return interceptors
	}
}
