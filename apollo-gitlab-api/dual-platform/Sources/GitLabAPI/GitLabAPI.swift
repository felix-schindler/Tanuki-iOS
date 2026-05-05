import Foundation

public class GitLabAPIModule {

    public static func createGitLabAPIType(id: UUID, delay: Double? = nil) async throws -> GitLabAPIType {
        if let delay = delay {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        return GitLabAPIType(id: id)
    }

    /// An example of a type that can be bridged between Swift and Kotlin
    public struct GitLabAPIType: Identifiable, Hashable, Codable {
        public var id: UUID
    }
}
