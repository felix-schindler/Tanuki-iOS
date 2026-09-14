import Foundation

#if !os(Android)
	import ApolloAPI
	import IOSGitLabAPI

	@_exported import ApolloAPI

	// Aliases so app code can keep the `GitLabAPI.<Type>` prefix.
	public typealias CurrentUserIssuesQuery = IOSGitLabAPI.CurrentUserIssuesQuery
	public typealias CurrentUserQuery = IOSGitLabAPI.CurrentUserQuery
	public typealias CurrentUserSnippetsQuery = IOSGitLabAPI.CurrentUserSnippetsQuery
	public typealias CurrentUserStarredProjectsQuery = IOSGitLabAPI.CurrentUserStarredProjectsQuery
	public typealias CurrentUserTodosQuery = IOSGitLabAPI.CurrentUserTodosQuery
	public typealias EpicIssuesQuery = IOSGitLabAPI.EpicIssuesQuery
	public typealias EpicQuery = IOSGitLabAPI.EpicQuery
	public typealias GroupCustomEmojiQuery = IOSGitLabAPI.GroupCustomEmojiQuery
	public typealias GroupEpicsQuery = IOSGitLabAPI.GroupEpicsQuery
	public typealias GroupIssuesQuery = IOSGitLabAPI.GroupIssuesQuery
	public typealias GroupLabelsQuery = IOSGitLabAPI.GroupLabelsQuery
	public typealias GroupMembersQuery = IOSGitLabAPI.GroupMembersQuery
	public typealias GroupMergeRequestsQuery = IOSGitLabAPI.GroupMergeRequestsQuery
	public typealias GroupMilestonesQuery = IOSGitLabAPI.GroupMilestonesQuery
	public typealias GroupQuery = IOSGitLabAPI.GroupQuery
	public typealias GroupsQuery = IOSGitLabAPI.GroupsQuery
	public typealias GroupTimelogsQuery = IOSGitLabAPI.GroupTimelogsQuery
	public typealias IssueQuery = IOSGitLabAPI.IssueQuery
	public typealias IssueStateMutation = IOSGitLabAPI.IssueStateMutation
	public typealias MergeRequestCommitsQuery = IOSGitLabAPI.MergeRequestCommitsQuery
	public typealias MergeRequestDiffsQuery = IOSGitLabAPI.MergeRequestDiffsQuery
	public typealias MergeRequestQuery = IOSGitLabAPI.MergeRequestQuery
	public typealias ProjectIssuesQuery = IOSGitLabAPI.ProjectIssuesQuery
	public typealias ProjectLabelsQuery = IOSGitLabAPI.ProjectLabelsQuery
	public typealias ProjectMembersQuery = IOSGitLabAPI.ProjectMembersQuery
	public typealias ProjectMergeRequestsQuery = IOSGitLabAPI.ProjectMergeRequestsQuery
	public typealias ProjectMilestonesQuery = IOSGitLabAPI.ProjectMilestonesQuery
	public typealias ProjectPipelinesQuery = IOSGitLabAPI.ProjectPipelinesQuery
	public typealias ProjectQuery = IOSGitLabAPI.ProjectQuery
	public typealias ProjectReleasesQuery = IOSGitLabAPI.ProjectReleasesQuery
	public typealias ProjectsQuery = IOSGitLabAPI.ProjectsQuery
	public typealias RepoTreeQuery = IOSGitLabAPI.RepoTreeQuery
	public typealias SnippetQuery = IOSGitLabAPI.SnippetQuery
	public typealias StarProjectMutation = IOSGitLabAPI.StarProjectMutation
	public typealias UserAssignedMergeRequestsQuery = IOSGitLabAPI.UserAssignedMergeRequestsQuery
	public typealias UserAuthoredMergeRequestsQuery = IOSGitLabAPI.UserAuthoredMergeRequestsQuery
	public typealias UserGroupsQuery = IOSGitLabAPI.UserGroupsQuery
	public typealias UserIssuesQuery = IOSGitLabAPI.UserIssuesQuery
	public typealias UserQuery = IOSGitLabAPI.UserQuery
	public typealias UserReviewRequestedMergeRequestsQuery = IOSGitLabAPI.UserReviewRequestedMergeRequestsQuery
	public typealias UserSnippetsQuery = IOSGitLabAPI.UserSnippetsQuery
	public typealias UserStarredProjectsQuery = IOSGitLabAPI.UserStarredProjectsQuery
	public typealias UserTimelogsQuery = IOSGitLabAPI.UserTimelogsQuery
	public typealias UserTodosQuery = IOSGitLabAPI.UserTodosQuery
	public typealias UsersQuery = IOSGitLabAPI.UsersQuery

	// On iOS, the wrapper types are aliases to Apollo-generated types
	// so existing code that uses switch/case and pattern matching still works.
	public typealias AccessLevelEnum = IOSGitLabAPI.AccessLevelEnum
	public typealias DetailedMergeStatus = IOSGitLabAPI.DetailedMergeStatus
	public typealias EpicState = IOSGitLabAPI.EpicState
	public typealias IssuableState = IOSGitLabAPI.IssuableState
	public typealias IssueState = IOSGitLabAPI.IssueState
	public typealias IssueStateEvent = IOSGitLabAPI.IssueStateEvent
	public typealias IssueType = IOSGitLabAPI.IssueType
	public typealias MergeRequestState = IOSGitLabAPI.MergeRequestState
	public typealias MergeStatus = IOSGitLabAPI.MergeStatus
	public typealias MilestoneStateEnum = IOSGitLabAPI.MilestoneStateEnum
	public typealias PipelineStatusEnum = IOSGitLabAPI.PipelineStatusEnum
	public typealias ProjectArchived = IOSGitLabAPI.ProjectArchived
	public typealias SubscriptionStatus = IOSGitLabAPI.SubscriptionStatus
	public typealias TodoActionEnum = IOSGitLabAPI.TodoActionEnum
	public typealias TodoStateEnum = IOSGitLabAPI.TodoStateEnum
	public typealias TodoTargetEnum = IOSGitLabAPI.TodoTargetEnum
	public typealias UserState = IOSGitLabAPI.UserState
	public typealias VerificationStatus = IOSGitLabAPI.VerificationStatus
	public typealias VisibilityLevelsEnum = IOSGitLabAPI.VisibilityLevelsEnum

	// GraphQLEnum is the Apollo wrapper type; typealias to ApolloAPI.GraphQLEnum
	public typealias GraphQLEnum = ApolloAPI.GraphQLEnum

#else

	// On Android, define standalone enums matching the Apollo Kotlin generated types.
	// The bridging layer maps these to their Kotlin equivalents.

	public enum AccessLevelEnum: String, CaseIterable, Hashable, Sendable, Codable {
		case noAccess = "NO_ACCESS"
		case minimalAccess = "MINIMAL_ACCESS"
		case guest = "GUEST"
		case planner = "PLANNER"
		case reporter = "REPORTER"
		case developer = "DEVELOPER"
		case maintainer = "MAINTAINER"
		case owner = "OWNER"
		case admin = "ADMIN"
	}

	public enum DetailedMergeStatus: String, CaseIterable, Hashable, Sendable, Codable {
		case unchecked = "UNCHECKED"
		case checking = "CHECKING"
		case mergeable = "MERGEABLE"
		case commitsStatus = "COMMITS_STATUS"
		case ciMustPass = "CI_MUST_PASS"
		case ciStillRunning = "CI_STILL_RUNNING"
		case discussionsNotResolved = "DISCUSSIONS_NOT_RESOLVED"
		case draftStatus = "DRAFT_STATUS"
		case notOpen = "NOT_OPEN"
		case notApproved = "NOT_APPROVED"
		case blockedStatus = "BLOCKED_STATUS"
		case externalStatusChecks = "EXTERNAL_STATUS_CHECKS"
		case preparing = "PREPARING"
		case jiraAssociation = "JIRA_ASSOCIATION"
		case conflict = "CONFLICT"
		case needRebase = "NEED_REBASE"
		case approvalsSyncing = "APPROVALS_SYNCING"
		case lockedPaths = "LOCKED_PATHS"
		case lockedLfsFiles = "LOCKED_LFS_FILES"
		case mergeTime = "MERGE_TIME"
		case securityPoliciesViolations = "SECURITY_POLICIES_VIOLATIONS"
		case titleNotMatching = "TITLE_NOT_MATCHING"
		case requestedChanges = "REQUESTED_CHANGES"
		case securityPolicyPipelineCheck = "SECURITY_POLICY_PIPELINE_CHECK"
	}

	public enum EpicState: String, CaseIterable, Hashable, Sendable, Codable {
		case all = "all"
		case opened = "opened"
		case closed = "closed"
	}

	public enum IssuableState: String, CaseIterable, Hashable, Sendable, Codable {
		case opened = "opened"
		case closed = "closed"
		case locked = "locked"
		case all = "all"
	}

	public enum IssueState: String, CaseIterable, Hashable, Sendable, Codable {
		case opened = "opened"
		case closed = "closed"
		case locked = "locked"
		case all = "all"
	}

	public enum IssueStateEvent: String, CaseIterable, Hashable, Sendable, Codable {
		case reopen = "REOPEN"
		case close = "CLOSE"
	}

	public enum IssueType: String, CaseIterable, Hashable, Sendable, Codable {
		case issue = "ISSUE"
		case incident = "INCIDENT"
		case testCase = "TEST_CASE"
		case requirement = "REQUIREMENT"
		case task = "TASK"
		case ticket = "TICKET"
		case objective = "OBJECTIVE"
		case keyResult = "KEY_RESULT"
		case epic = "EPIC"
	}

	public enum MergeRequestState: String, CaseIterable, Hashable, Sendable, Codable {
		case merged = "merged"
		case opened = "opened"
		case closed = "closed"
		case locked = "locked"
		case all = "all"
	}

	public enum MergeStatus: String, CaseIterable, Hashable, Sendable, Codable {
		case unchecked = "UNCHECKED"
		case checking = "CHECKING"
		case canBeMerged = "CAN_BE_MERGED"
		case cannotBeMerged = "CANNOT_BE_MERGED"
		case cannotBeMergedRecheck = "CANNOT_BE_MERGED_RECHECK"
	}

	public enum MilestoneStateEnum: String, CaseIterable, Hashable, Sendable, Codable {
		case active = "active"
		case closed = "closed"
	}

	public enum PipelineStatusEnum: String, CaseIterable, Hashable, Sendable, Codable {
		case created = "CREATED"
		case waitingForResource = "WAITING_FOR_RESOURCE"
		case preparing = "PREPARING"
		case waitingForCallback = "WAITING_FOR_CALLBACK"
		case pending = "PENDING"
		case running = "RUNNING"
		case failed = "FAILED"
		case success = "SUCCESS"
		case canceling = "CANCELING"
		case canceled = "CANCELED"
		case skipped = "SKIPPED"
		case manual = "MANUAL"
		case scheduled = "SCHEDULED"
	}

	public enum ProjectArchived: String, CaseIterable, Hashable, Sendable, Codable {
		case only = "ONLY"
		case include = "INCLUDE"
		case exclude = "EXCLUDE"
	}

	public enum SubscriptionStatus: String, CaseIterable, Hashable, Sendable, Codable {
		case explicitlySubscribed = "EXPLICITLY_SUBSCRIBED"
		case explicitlyUnsubscribed = "EXPLICITLY_UNSUBSCRIBED"
	}

	public enum TodoActionEnum: String, CaseIterable, Hashable, Sendable, Codable {
		case assigned = "assigned"
		case reviewRequested = "review_requested"
		case mentioned = "mentioned"
		case buildFailed = "build_failed"
		case marked = "marked"
		case approvalRequired = "approval_required"
		case unmergeable = "unmergeable"
		case directlyAddressed = "directly_addressed"
		case memberAccessRequested = "member_access_requested"
		case reviewSubmitted = "review_submitted"
		case sshKeyExpired = "ssh_key_expired"
		case sshKeyExpiringSoon = "ssh_key_expiring_soon"
		case mergeTrainRemoved = "merge_train_removed"
		case okrCheckinRequested = "okr_checkin_requested"
		case addedApprover = "added_approver"
		case duoProAccessGranted = "duo_pro_access_granted"
		case duoEnterpriseAccessGranted = "duo_enterprise_access_granted"
		case duoCoreAccessGranted = "duo_core_access_granted"
		case duoWorkflowInputRequired = "duo_workflow_input_required"
	}

	public enum TodoStateEnum: String, CaseIterable, Hashable, Sendable, Codable {
		case pending = "pending"
		case done = "done"
	}

	public enum TodoTargetEnum: String, CaseIterable, Hashable, Sendable, Codable {
		case commit = "COMMIT"
		case issue = "ISSUE"
		case workitem = "WORKITEM"
		case mergerequest = "MERGEREQUEST"
		case design = "DESIGN"
		case alert = "ALERT"
		case project = "PROJECT"
		case namespace = "NAMESPACE"
		case key = "KEY"
		case wikipagemeta = "WIKIPAGEMETA"
		case epic = "EPIC"
		case user = "USER"
		case vulnerability = "VULNERABILITY"
		case complianceViolation = "COMPLIANCE_VIOLATION"
		case duoWorkflow = "DUO_WORKFLOW"
	}

	public enum UserState: String, CaseIterable, Hashable, Sendable, Codable {
		case active = "active"
		case blocked = "blocked"
		case deactivated = "deactivated"
		case banned = "banned"
		case ldapBlocked = "ldap_blocked"
		case blockedPendingApproval = "blocked_pending_approval"
	}

	public enum VerificationStatus: String, CaseIterable, Hashable, Sendable, Codable {
		case unverified = "UNVERIFIED"
		case verified = "VERIFIED"
		case sameUserDifferentEmail = "SAME_USER_DIFFERENT_EMAIL"
		case otherUser = "OTHER_USER"
		case unverifiedKey = "UNVERIFIED_KEY"
		case unknownKey = "UNKNOWN_KEY"
		case multipleSignatures = "MULTIPLE_SIGNATURES"
		case revokedKey = "REVOKED_KEY"
		case verifiedSystem = "VERIFIED_SYSTEM"
		case unverifiedAuthorEmail = "UNVERIFIED_AUTHOR_EMAIL"
		case expiredKey = "EXPIRED_KEY"
		case verifiedCa = "VERIFIED_CA"
	}

	public enum VisibilityLevelsEnum: String, CaseIterable, Hashable, Sendable, Codable {
		case `private` = "private"
		case `internal` = "internal"
		case `public` = "public"
	}

	// On Android, a simple wrapper compatible with Skip's bridging.
	// The Kotlin adapter maps Apollo Kotlin enum values through this type.
	public struct GraphQLEnum<T>: RawRepresentable, Hashable, Sendable {
		public let rawValue: String
		// SKIP @nobridge
		public init(rawValue: String) { self.rawValue = rawValue }
	}

#endif
