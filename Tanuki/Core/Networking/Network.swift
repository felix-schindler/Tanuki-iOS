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

	private(set) var apollo: ApolloClient

	init() {
		self.apollo = Network.buildApolloClient()
	}

	func resetApolloClient() {
		self.apollo = Network.buildApolloClient()
	}

	private static func buildApolloClient() -> ApolloClient {
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
	}
}

@MainActor
final class AuthorizationInterceptor: GraphQLInterceptor {
	func intercept<Request: GraphQLRequest>(
		request: Request,
		next: NextInterceptorFunction<Request>
	) async throws -> InterceptorResultStream<Request> {
		await Auth.ensureValidToken()

		var req = request
		req.addHeader(name: "Authorization", value: "Bearer \(API.token)")
		let instanceId = API.currentInstance?.id

		let stream = await next(req)
		return await stream.mapErrors { error in
			guard Auth.isUnauthorized(error), let instanceId else {
				throw error
			}
			_ = await Auth.handleUnauthorized(instanceId: instanceId)
			throw error
		}
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
