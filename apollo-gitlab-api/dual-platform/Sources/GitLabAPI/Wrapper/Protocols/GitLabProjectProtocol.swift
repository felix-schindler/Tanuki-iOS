import Foundation

#if !os(Android)
import IOSGitLabAPI
#endif

public protocol GitLabProjectProtocol {
    var fullPath: String { get }
    var nameWithNamespace: String { get }
    var avatarUrl: String? { get }
    var visibility: String? { get }
}

/// Cross-platform struct wrapping a GitLab project from a Projects query.
///
/// **iOS**: Construct directly from an Apollo iOS type:
/// ```swift
/// let node = result.data?.projects?.nodes?.first
/// let project = node.map { GitLabProject(from: $0) }
/// ```
///
/// **Android**: The Skip bridge generates a Kotlin class `GitLabProject`
/// (in package `git.lab.api`) with the same constructor signature.
/// Use the adapter function in `de.schindlerfelix.gitlab.bridge` to
/// convert Apollo Kotlin types:
/// ```kotlin
/// val node = response.data?.projects?.nodes?.firstOrNull()
/// val project = node?.toGitLabProject()
/// ```
public struct GitLabProject: GitLabProjectProtocol, Identifiable, Hashable, Sendable {
    public let fullPath: String
    public let nameWithNamespace: String
    public let avatarUrl: String?
    public let visibility: String?

    public var id: String { fullPath }

    public init(
        fullPath: String,
        nameWithNamespace: String,
        avatarUrl: String?,
        visibility: String?
    ) {
        self.fullPath = fullPath
        self.nameWithNamespace = nameWithNamespace
        self.avatarUrl = avatarUrl
        self.visibility = visibility
    }

    #if !os(Android)
    public init(from node: IOSGitLabAPI.ProjectsQuery.Data.Projects.Node) {
        self.fullPath = node.fullPath
        self.nameWithNamespace = node.nameWithNamespace
        self.avatarUrl = node.avatarUrl
        self.visibility = node.visibility
    }
    #endif
}
