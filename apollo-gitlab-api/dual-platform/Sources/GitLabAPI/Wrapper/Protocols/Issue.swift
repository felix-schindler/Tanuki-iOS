import Foundation

public protocol SmallIssue {
    var iid: String { get }
    var title: String { get }
    var reference: String { get }
    var stateRawValue: String { get }
    var upvotes: Int { get }
    var downvotes: Int { get }
    var userNotesCount: Int { get }
    var _author: MyAuthor { get }
    var createdAt: String { get }
    var webUrl: String { get }
}

public protocol IssueProjectMembership {
    var fullPath: String? { get }
    var _issues: [SmallIssue?]? { get }
}
