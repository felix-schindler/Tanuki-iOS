import Foundation

/// How the client should resolve the query against cache and network.
public enum FetchStrategy: Sendable {
    case cacheFirst
    case networkOnly
}

/// A single GraphQL operation (query or mutation) that can be sent to the GitLab API.
public protocol GitLabQuery: Sendable {
    associatedtype Response: Decodable, Sendable

    var operationName: String { get }
    var queryString: String { get }

    /// Pre-encoded JSON body for the `variables` field of the GraphQL request.
    var variablesJSON: Data { get }
}

extension GitLabQuery {
    var cacheKey: String {
        var hasher = Hasher()
        hasher.combine(operationName)
        hasher.combine(variablesJSON)
        return "gitlab.\(operationName).\(hasher.finalize())"
    }
}

// MARK: - Wire types

/// The JSON body sent to the GitLab GraphQL endpoint.
struct GraphQLRequestBody: Encodable {
    let query: String
    let variables: [String: AnyEncodableValue]
    let operationName: String
}

/// Type-erased encodable value for the variables dictionary.
struct AnyEncodableValue: Encodable {
    private let encode: (Encoder) throws -> Void

    init<T: Encodable>(_ value: T) {
        self.encode = { encoder in try value.encode(to: encoder) }
    }

    func encode(to encoder: Encoder) throws {
        try encode(encoder)
    }
}

/// The JSON envelope returned by the GitLab GraphQL endpoint.
struct GraphQLResponseBody<Data: Decodable>: Decodable {
    let data: Data?
    let errors: [GraphQLResponseError]?
}

struct GraphQLResponseError: Decodable {
    let message: String
}
