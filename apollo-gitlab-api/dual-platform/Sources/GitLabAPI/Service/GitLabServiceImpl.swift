import Foundation

/// Single cross-platform implementation of `GitLabServiceType`.
///
/// Uses `Alamofire` and SkipKit's `Cache` for in-memory response caching.
final class GitLabServiceImpl: GitLabServiceType, @unchecked Sendable {

    private let client: GitLabClient

    init(host: String, token: String) {
        self.client = GitLabClient(host: host, token: token)
    }

    func fetch<Q: GitLabQuery>(_ query: Q, strategy: FetchStrategy) async throws -> Q.Response where Q.Response: Decodable {
        try await client.fetch(query, strategy: strategy)
    }

    func clearCache() async throws {
        client.clearCache()
    }
}
