import Foundation

// Concrete Codable structs that satisfy the wrapper protocols.
// These are the types decoded from the GraphQL JSON response.

// MARK: - SmallProject

public struct SmallProjectStruct: SmallProject, Codable, Sendable {
    public let avatarUrl: String?
    public let nameWithNamespace: String
    public let visibility: String?
    public let fullPath: String
}

// MARK: - Group

public struct GroupStruct: Group, Codable, Sendable {
    public let avatarUrl: String?
    public let _name: String?
    public let fullPath: String
    public let visibility: String?
    public let groupMembersCount: Int
    public let projectsCount: Int
    public let _accessLevel: String?
}

// MARK: - SmallIssue

public struct SmallIssueStruct: SmallIssue, Codable, Sendable {
    public let iid: String
    public let title: String
    public let reference: String
    public let state: IssueState
    public let upvotes: Int
    public let downvotes: Int
    public let userNotesCount: Int
    public let _author: MyAuthor
    public let createdAt: String
    public let webUrl: String
}

// MARK: - SmallMergeRequest

public struct SmallMergeRequestStruct: SmallMergeRequest, Codable, Sendable {
    public let iid: String
    public let title: String
    public let reference: String
    public let state: MergeRequestState
    public let upvotes: Int
    public let downvotes: Int
    public let userNotesCount: Int?
    public let _author: MyAuthor?
    public let createdAt: String
    public let webUrl: String?
}

// MARK: - UserSmallMergeRequest

public struct UserSmallMergeRequestStruct: UserSmallMergeRequest, Codable, Sendable {
    public let iid: String
    public let title: String
    public let reference: String
    public let state: MergeRequestState
    public let upvotes: Int
    public let downvotes: Int
    public let userNotesCount: Int?
    public let _author: MyAuthor?
    public let createdAt: String
    public let webUrl: String?
    public let _project: ProjectPath
}

// MARK: - MyLabel

public struct MyLabelStruct: MyLabel, Codable, Sendable {
    public let id: String
    public let title: String
    public let description: String?
    public let color: String
    public let textColor: String
}

// MARK: - Milestone

public struct MilestoneStruct: Milestone, Codable, Sendable {
    public let iid: String
    public let state: MilestoneStateEnum
    public let title: String
    public let description: String?
    public let expired: Bool
    public let startDate: String?
    public let dueDate: String?
    public let _stats: MyStats?
    public let webPath: String
}

// MARK: - Timelog

public struct TimelogStruct: Timelog, Codable, Sendable {
    public let id: String
    public let _user: MyAuthor
    public let spentAt: String?
    public let summary: String?
    public let timeSpent: Int
    public let _project: T_Project
    public let _issue: T_Issue?
    public let _mergeRequest: T_MR?
}

// MARK: - Todo

public struct TodoStruct: Todo, Decodable, Sendable {
    public let id: String
    public let body: String
    public let _groupPath: String?
    public let state: TodoStateEnum
    public let action: TodoActionEnum
    public let _author: MyAuthor
    public let _webUrl: String?
    public let createdAt: String
    public let targetType: TodoTargetEnum
    public let _project: SmallProjectStruct?
}

// MARK: - Snippet

public struct SnippetStruct: Snippet, Codable, Sendable {
    public let id: String
    public let title: String
    public let _author: MyAuthor?
    public let createdAt: String
    public let webUrl: String
    public let visibilityLevel: VisibilityLevelsEnum
}

// MARK: - Release

public struct ReleaseStruct: Release, Codable, Sendable {
    public let _author: MyAuthor?
}

// MARK: - NewCommit

public struct NewCommitStruct: NewCommit, Codable, Sendable {
    public let id: String
    public let title: String?
    public let shortId: String
    public let authorName: String?
    public let authoredDate: String?
    public let webUrl: String
    public let _signatureVerificationStatus: String?
    public let _lastPipelineStatus: PipelineStatusEnum?
}

// MARK: - Member

public struct MemberStruct: Member, Codable, Sendable {
    public let id: String
    public let createdAt: String?
    public let expiresAt: String?
    public let _accessLevel: String?
    public let _user: MyAuthor?
    public let _createdBy: MyAuthor?
}

// MARK: - User (for CurrentUser / User queries)

public struct UserStruct: User, Codable, Sendable {
    public let id: String
    public let avatarUrl: String?
    public let name: String
    public let username: String
    public let bot: Bool
    public let pronouns: String?
    public let state: UserState
    public let _status: UserStatus?
    public let bio: String?
    public let location: String?
    public let jobTitle: String?
    public let organization: String?
    public let discord: String?
    public let twitter: String?
    public let linkedin: String?
    public let publicEmail: String?
    public let groupCount: Int?
    public let createdAt: String?
    public let webUrl: String
}
