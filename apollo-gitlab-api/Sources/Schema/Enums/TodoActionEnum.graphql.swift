// @generated
// This file was automatically generated and should not be edited.

@_spi(Internal) import ApolloAPI

nonisolated public enum TodoActionEnum: String, EnumType {
  /// Todo action name for assigned.
  case assigned = "assigned"
  /// Todo action name for review_requested.
  case reviewRequested = "review_requested"
  /// Todo action name for mentioned.
  case mentioned = "mentioned"
  /// Todo action name for build_failed.
  case buildFailed = "build_failed"
  /// Todo action name for marked.
  case marked = "marked"
  /// Todo action name for approval_required.
  case approvalRequired = "approval_required"
  /// Todo action name for unmergeable.
  case unmergeable = "unmergeable"
  /// Todo action name for directly_addressed.
  case directlyAddressed = "directly_addressed"
  /// Todo action name for member_access_requested.
  case memberAccessRequested = "member_access_requested"
  /// Todo action name for review_submitted.
  case reviewSubmitted = "review_submitted"
  /// Todo action name for ssh_key_expired.
  case sshKeyExpired = "ssh_key_expired"
  /// Todo action name for ssh_key_expiring_soon.
  case sshKeyExpiringSoon = "ssh_key_expiring_soon"
  /// Todo action name for transfer_failed.
  case transferFailed = "transfer_failed"
  /// Todo action name for merge_train_removed.
  case mergeTrainRemoved = "merge_train_removed"
  /// Todo action name for okr_checkin_requested.
  case okrCheckinRequested = "okr_checkin_requested"
  /// Todo action name for added_approver.
  case addedApprover = "added_approver"
  /// Todo action name for duo_pro_access_granted.
  case duoProAccessGranted = "duo_pro_access_granted"
  /// Todo action name for duo_enterprise_access_granted.
  case duoEnterpriseAccessGranted = "duo_enterprise_access_granted"
  /// Todo action name for duo_core_access_granted.
  case duoCoreAccessGranted = "duo_core_access_granted"
  /// Todo action name for duo_workflow_input_required.
  case duoWorkflowInputRequired = "duo_workflow_input_required"
}
