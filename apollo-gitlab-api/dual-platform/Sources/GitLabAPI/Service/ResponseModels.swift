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

	public init(
		iid: String, title: String, reference: String, state: IssueState,
		upvotes: Int, downvotes: Int, userNotesCount: Int,
		_author: MyAuthor, createdAt: String, webUrl: String
	) {
		self.iid = iid
		self.title = title
		self.reference = reference
		self.state = state
		self.upvotes = upvotes
		self.downvotes = downvotes
		self.userNotesCount = userNotesCount
		self._author = _author
		self.createdAt = createdAt
		self.webUrl = webUrl
	}
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
	public let description: String?
	public let sshUrlToRepo: String?
	public let httpUrlToRepo: String?
	public let userPermissions: SnippetStruct_UserPermissions?
	public let blobs: SnippetStruct_Blobs?
	public let notes: SnippetStruct_Notes?
}

public struct SnippetStruct_UserPermissions: Codable, Sendable {
	public let createNote: String?
}

public struct SnippetStruct_Blobs_Nodes: Codable, Sendable {
	public let name: String?
	public let size: Int
	public let rawPlainData: String?
}

public struct SnippetStruct_Blobs: Codable, Sendable {
	public let nodes: [SnippetStruct_Blobs_Nodes?]?
}

public struct SnippetStruct_Notes_Nodes: Note, Codable, Sendable {
	public let id: String?
	public let system: Bool
	public let systemNoteIconName: String?
	public let body: String
	public let _author: MyAuthor?
	public let createdAt: String
	public let updatedAt: String
	public let maxAccessLevelOfAuthor: String?
}

public struct SnippetStruct_Notes: Codable, Sendable {
	public let nodes: [SnippetStruct_Notes_Nodes?]?
}

// MARK: - Release

public struct ReleaseStruct: Release, Codable, Sendable {
	public let _author: MyAuthor?
	public let id: String?
	public let name: String?
	public let description: String?
	public let tagName: String?
	public let releasedAt: String?
	public let commit: ReleaseCommitStruct?
	public let milestones: ReleaseMilestoneConnectionStruct?
	public let assets: ReleaseAssetConnectionStruct?
}

public struct ReleaseCommitStruct: Codable, Sendable {
	public let shortId: String?
}

public struct ReleaseMilestoneConnectionStruct: Codable, Sendable {
	public let nodes: [ReleaseMilestoneNodeStruct?]?
}

public struct ReleaseMilestoneNodeStruct: Codable, Sendable {
	public let id: String?
	public let title: String?
}

public struct ReleaseAssetConnectionStruct: Codable, Sendable {
	public let count: Int?
	public let links: ReleaseAssetLinkConnectionStruct?
	public let sources: ReleaseAssetSourceConnectionStruct?
}

public struct ReleaseAssetLinkConnectionStruct: Codable, Sendable {
	public let nodes: [ReleaseAssetLinkStruct?]?
}

public struct ReleaseAssetLinkStruct: Codable, Sendable {
	public let id: String?
	public let name: String?
	public let url: String?
}

public struct ReleaseAssetSourceConnectionStruct: Codable, Sendable {
	public let nodes: [ReleaseAssetSourceStruct?]?
}

public struct ReleaseAssetSourceStruct: Codable, Sendable {
	public let url: String?
	public let format: String?
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

	public init(
		id: String, title: String?, shortId: String, authorName: String?,
		authoredDate: String?, webUrl: String,
		_signatureVerificationStatus: String?, _lastPipelineStatus: PipelineStatusEnum?
	) {
		self.id = id
		self.title = title
		self.shortId = shortId
		self.authorName = authorName
		self.authoredDate = authoredDate
		self.webUrl = webUrl
		self._signatureVerificationStatus = _signatureVerificationStatus
		self._lastPipelineStatus = _lastPipelineStatus
	}
}

// MARK: - Member

public struct MemberStruct: Member, Codable, Sendable {
	public let id: String
	public let createdAt: String?
	public let expiresAt: String?
	public let _accessLevel: String?
	public let _user: MyAuthor?
	public let _createdBy: MyAuthor?

	public init(
		id: String, createdAt: String?, expiresAt: String?,
		_accessLevel: String?, _user: MyAuthor?, _createdBy: MyAuthor?
	) {
		self.id = id
		self.createdAt = createdAt
		self.expiresAt = expiresAt
		self._accessLevel = _accessLevel
		self._user = _user
		self._createdBy = _createdBy
	}
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

	public init(
		id: String, avatarUrl: String?, name: String, username: String, bot: Bool,
		pronouns: String?, state: UserState, status: UserStatus?,
		bio: String?, location: String?, jobTitle: String?, organization: String?,
		discord: String?, twitter: String?, linkedin: String?,
		publicEmail: String?, groupCount: Int?, createdAt: String?, webUrl: String
	) {
		self.id = id
		self.avatarUrl = avatarUrl
		self.name = name
		self.username = username
		self.bot = bot
		self.pronouns = pronouns
		self.state = state
		self._status = status
		self.bio = bio
		self.location = location
		self.jobTitle = jobTitle
		self.organization = organization
		self.discord = discord
		self.twitter = twitter
		self.linkedin = linkedin
		self.publicEmail = publicEmail
		self.groupCount = groupCount
		self.createdAt = createdAt
		self.webUrl = webUrl
	}
}
