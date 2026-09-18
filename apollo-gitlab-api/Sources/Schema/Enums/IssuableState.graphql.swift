// @generated
// This file was automatically generated and should not be edited.

@_spi(Internal) import ApolloAPI

/// State of a GitLab issue or merge request
nonisolated public enum IssuableState: String, EnumType {
  /// In open state.
  case opened = "opened"
  /// In closed state.
  case closed = "closed"
  /// Discussion has been locked.
  case locked = "locked"
  /// All available.
  case all = "all"
}
