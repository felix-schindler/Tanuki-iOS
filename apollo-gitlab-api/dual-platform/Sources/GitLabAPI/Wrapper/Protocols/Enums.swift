import Foundation

// All GitLab GraphQL enum types.  Each mirrors the UPPER_SNAKE_CASE raw values
// that the GitLab API returns, making them directly Codable without any wrapper.

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
