// @generated
// This file was automatically generated and should not be edited.

@_spi(Internal) import ApolloAPI

/// Detailed representation of whether a GitLab merge request can be merged.
nonisolated public enum DetailedMergeStatus: String, EnumType {
  /// Merge status has not been checked.
  case unchecked = "UNCHECKED"
  /// Currently checking for mergeability.
  case checking = "CHECKING"
  /// Branch can be merged.
  case mergeable = "MERGEABLE"
  /// Source branch exists and contains commits.
  case commitsStatus = "COMMITS_STATUS"
  /// Pipeline must succeed before merging.
  case ciMustPass = "CI_MUST_PASS"
  /// Pipeline is still running.
  case ciStillRunning = "CI_STILL_RUNNING"
  /// Discussions must be resolved before merging.
  case discussionsNotResolved = "DISCUSSIONS_NOT_RESOLVED"
  /// Merge request must not be draft before merging.
  case draftStatus = "DRAFT_STATUS"
  /// Merge request must be open before merging.
  case notOpen = "NOT_OPEN"
  /// Merge request must be approved before merging.
  case notApproved = "NOT_APPROVED"
  /// Merge request dependencies must be merged.
  case blockedStatus = "BLOCKED_STATUS"
  /// Status checks must pass.
  case externalStatusChecks = "EXTERNAL_STATUS_CHECKS"
  /// Merge request diff is being created.
  case preparing = "PREPARING"
  /// Either the title or description must reference a Jira issue.
  case jiraAssociation = "JIRA_ASSOCIATION"
  /// There are conflicts between the source and target branches.
  case conflict = "CONFLICT"
  /// Merge request needs to be rebased.
  case needRebase = "NEED_REBASE"
  /// Merge request approvals currently syncing.
  case approvalsSyncing = "APPROVALS_SYNCING"
  /// Merge request includes locked paths.
  case lockedPaths = "LOCKED_PATHS"
  /// Merge request includes locked LFS files.
  case lockedLfsFiles = "LOCKED_LFS_FILES"
  /// Merge request may not be merged until after the specified time.
  case mergeTime = "MERGE_TIME"
  /// All policy rules must be satisfied.
  case securityPoliciesViolations = "SECURITY_POLICIES_VIOLATIONS"
  /// Merge request title does not match required regex.
  case titleNotMatching = "TITLE_NOT_MATCHING"
}
