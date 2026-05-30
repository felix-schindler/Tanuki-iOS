import Foundation

/// Single cross-platform implementation of `GitLabServiceType`.
///
/// Uses `Alamofire` (bridged to both iOS and Android by Skip) and
/// SkipKit's `Cache` for in-memory response caching.
final class GitLabServiceImpl: GitLabServiceType, @unchecked Sendable {

    private let client: GitLabClient

    init(host: String, token: String) {
        self.client = GitLabClient(host: host, token: token)
    }

    #if !SKIP
    func fetch<Q: GitLabQuery>(_ query: Q, strategy: FetchStrategy) async throws -> Q.Response {
        try await client.fetch(query, strategy: strategy)
    }
    #endif

    func clearCache() async throws {
        client.clearCache()
    }
}
