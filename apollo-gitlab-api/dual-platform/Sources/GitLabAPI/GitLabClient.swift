import Alamofire
import Foundation
import SkipKit

/// HTTP client that sends GraphQL queries to a GitLab instance.
final class GitLabClient: @unchecked Sendable {
	private let host: String
	private let token: String
	private let cache: Cache<String, Data>
	private let decoder: JSONDecoder
	private let session: Session

	init(host: String, token: String) {
		self.host = host
		self.token = token
		self.cache = Cache<String, Data>(
			evictOnBackground: true,
			limit: 50 * 1024 * 1024,
			cost: { $0.count }
		)
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		self.decoder = decoder
		self.session = Session.default
	}

	// MARK: - Public API

	func fetch<Q: GitLabQuery>(
		_ query: Q,
		strategy: FetchStrategy = .cacheFirst
	) async throws -> Q.Response where Q.Response: Decodable {
		if strategy == .cacheFirst, let cached = cachedResponse(for: query) {
			Task.detached { [weak self] in
				_ = try? await self?.requestAndCache(query)
			}
			return cached
		}
		return try await requestAndCache(query)
	}

	func clearCache() {
		cache.clear()
	}

	// MARK: - Private

	private func cachedResponse<Q: GitLabQuery>(for query: Q) -> Q.Response? where Q.Response: Decodable {
		guard let data = cache.getValue(for: query.cacheKey) else { return nil }
		return try? decoder.decode(GraphQLResponseBody<Q.Response>.self, from: data).data
	}

	private func requestAndCache<Q: GitLabQuery>(_ query: Q) async throws -> Q.Response where Q.Response: Decodable {
		let headers: HTTPHeaders = [
			"Content-Type": "application/json",
			"Authorization": "Bearer \(token)",
		]

		let body: [String: Any] = [
			"query": query.queryString,
			"variables": try JSONSerialization.jsonObject(with: query.variablesJSON),
			"operationName": query.operationName,
		]
		let bodyData = try JSONSerialization.data(withJSONObject: body)

		var request = try URLRequest(
			url: URL(string: "https://\(host)/api/graphql")!,
			method: .post,
			headers: headers
		)
		request.httpBody = bodyData

		let data = try await session.request(request)
			.validate()
			.serializingData()
			.value

		cache.putValue(data, for: query.cacheKey)

		let envelope = try decoder.decode(GraphQLResponseBody<Q.Response>.self, from: data)
		if let errors = envelope.errors, !errors.isEmpty {
			throw GitLabError.graphql(errors.map(\.message))
		}
		guard let value = envelope.data else {
			throw GitLabError.noData
		}
		return value
	}
}
