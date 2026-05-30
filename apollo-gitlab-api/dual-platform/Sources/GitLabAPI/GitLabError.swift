import Foundation

public enum GitLabError: Error, LocalizedError {
    case httpError(Int, String?)
    case graphql([String])
    case noData
    case decodingFailed(Error)

    public var errorDescription: String? {
        switch self {
        case .httpError(let code, let body):
            return "HTTP \(code)" + (body.map { ": \($0)" } ?? "")
        case .graphql(let messages):
            return messages.joined(separator: "; ")
        case .noData:
            return "No data in GraphQL response"
        case .decodingFailed(let error):
            return "Decoding failed: \(error.localizedDescription)"
        }
    }
}
