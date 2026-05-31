import Foundation

public protocol GitLabServiceType: AnyObject, Sendable {
    func clearCache() async throws
    func fetch<Q: GitLabQuery>(_ query: Q, strategy: FetchStrategy) async throws -> Q.Response where Q.Response: Decodable
}
