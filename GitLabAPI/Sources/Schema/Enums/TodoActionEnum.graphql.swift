// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public enum TodoActionEnum: String, EnumType {
  /// User was assigned.
  case assigned = "assigned"
  /// User was mentioned.
  case mentioned = "mentioned"
  /// Build triggered by the user failed.
  case buildFailed = "build_failed"
  /// User added a to-do item.
  case marked = "marked"
  /// User was set as an approver.
  case approvalRequired = "approval_required"
  /// Merge request authored by the user could not be merged.
  case unmergeable = "unmergeable"
  /// User was directly addressed.
  case directlyAddressed = "directly_addressed"
  /// Merge request authored by the user was removed from the merge train.
  case mergeTrainRemoved = "merge_train_removed"
  /// Review was requested from the user.
  case reviewRequested = "review_requested"
  /// Group or project access requested from the user.
  case memberAccessRequested = "member_access_requested"
  /// Merge request authored by the user received a review.
  case reviewSubmitted = "review_submitted"
  /// An OKR assigned to the user requires an update.
  case okrCheckinRequested = "okr_checkin_requested"
}
