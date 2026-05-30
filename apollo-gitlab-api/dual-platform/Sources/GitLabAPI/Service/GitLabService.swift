import Foundation

public protocol GitLabServiceType: AnyObject, Sendable {
    func clearCache() async throws
    #if !SKIP
    func fetch<Q: GitLabQuery>(_ query: Q, strategy: FetchStrategy) async throws -> Q.Response
    #endif
}
