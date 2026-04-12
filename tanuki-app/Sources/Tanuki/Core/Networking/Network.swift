//
//  Network.swift
//  Tanuki
//
//  Created by Felix Schindler on 26.02.24.
//

import Apollo
import ApolloAPI
import ApolloSQLite
import Foundation

@MainActor
final class Network {
	static let shared = Network()

	private(set) lazy var apollo: ApolloClient = {
		let documentsPath = NSSearchPathForDirectoriesInDomains(
			.documentDirectory,
			.userDomainMask,
			true
		).first!
		let documentsURL = URL(fileURLWithPath: documentsPath)
		let sqliteFileURL = documentsURL.appendingPathComponent("tanuki_graphql_cache.sqlite")

		// Cache on disk; Fall back to in-memory cache if unavailable
		var cache: NormalizedCache
		do {
			cache = try SQLiteNormalizedCache(fileURL: sqliteFileURL)
		} catch let error {
			print("Using in-memory cache", error)
			cache = InMemoryNormalizedCache()
		}

		let store = ApolloStore(cache: cache)

		let transport = RequestChainNetworkTransport(
			urlSession: URLSession.shared,
			interceptorProvider: NetworkInterceptorProvider(),
			store: store,
			endpointURL: API.graphUrl
		)

		return ApolloClient(networkTransport: transport, store: store)
	}()
}

@MainActor
final class AuthorizationInterceptor: GraphQLInterceptor {
	func intercept<Request: GraphQLRequest>(
		request: Request,
		next: NextInterceptorFunction<Request>
	) async throws -> InterceptorResultStream<Request> {
		var req = request
		req.addHeader(name: "Authorization", value: "Bearer \(API.token)")

		return await next(req)
	}
}

final class NetworkInterceptorProvider: InterceptorProvider {
	nonisolated func graphQLInterceptors<Operation: GraphQLOperation>(for operation: Operation)
		-> [any GraphQLInterceptor]
	{
		return [
			AuthorizationInterceptor()
		]
	}
}
