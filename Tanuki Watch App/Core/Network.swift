//
//  Network.swift
//  Tanuki
//
//  Created by Felix Schindler on 26.02.24.
//

import Apollo
import ApolloAPI
import SwiftUI

class API {
	/// GitLab host
	@AppStorage("domain", store: UserDefaults(suiteName: "de.schindlerfelix.GitLab"))
	public static var host: String = "gitlab.com"
	
	/// GitLab token
	@AppStorage("token", store: UserDefaults(suiteName: "de.schindlerfelix.GitLab"))
	public static var token: String = ""
		
	public static var url: URL {
		return URL(string: "https://\(host)")!
	}
	
	public static var graphUrl: URL {
		return URL(string: "https://\(host)/api/graphql")!
	}
}

class Network {
	static let shared = Network()

	private(set) lazy var apollo: ApolloClient = {
		let store = ApolloStore(cache: InMemoryNormalizedCache())

		let transport = RequestChainNetworkTransport(
			urlSession: URLSession.shared,
			interceptorProvider: NetworkInterceptorProvider(),
			store: store,
			endpointURL: API.graphUrl
		)

		return ApolloClient(networkTransport: transport, store: store)
	}()
}

final class AuthorizationInterceptor: GraphQLInterceptor {
	func intercept<Request: GraphQLRequest>(
	  request: Request,
	  next: NextInterceptorFunction<Request>
	) async throws -> InterceptorResultStream<Request> {
		var req = request
		req.addHeader(name: "Authorization", value: "Bearer \(await API.token)")

		return await next(req)
	}
}

final class NetworkInterceptorProvider: InterceptorProvider {
	func graphQLInterceptors<Operation: GraphQLOperation>(for operation: Operation)
		-> [any GraphQLInterceptor]
	{
		return [
			AuthorizationInterceptor()
		]
	}
}
