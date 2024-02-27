// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// Detailed representation of whether a GitLab merge request can be merged.
public enum DetailedMergeStatus: String, EnumType {
  /// Merge status has not been checked.
  case unchecked = "UNCHECKED"
  /// Currently checking for mergeability.
  case checking = "CHECKING"
  /// Branch can be merged.
  case mergeable = "MERGEABLE"
  /// Can not merge the source into the target branch, potential conflict.
  case brokenStatus = "BROKEN_STATUS"
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
  /// There are denied policies for the merge request.
  case policiesDenied = "POLICIES_DENIED"
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
}
