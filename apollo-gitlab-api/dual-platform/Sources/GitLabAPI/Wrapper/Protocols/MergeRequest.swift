import Foundation

public struct ProjectPath: Codable, Hashable, Sendable {
    public var fullPath: String
    public init(fullPath: String) { self.fullPath = fullPath }
}

public protocol SmallMergeRequest: Sendable {
    var iid: String { get }
    var title: String { get }
    var reference: String { get }
    var state: MergeRequestState { get }
    var upvotes: Int { get }
    var downvotes: Int { get }
    var userNotesCount: Int? { get }
    var _author: MyAuthor? { get }
    var createdAt: String { get }
    var webUrl: String? { get }
}

public protocol MergeRequest: Sendable {
    var _author: MyAuthor? { get }
}

public protocol UserSmallMergeRequest: SmallMergeRequest {
    var _project: ProjectPath { get }
}
