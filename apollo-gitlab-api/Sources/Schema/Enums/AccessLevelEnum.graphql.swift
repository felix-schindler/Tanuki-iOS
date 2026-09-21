// @generated
// This file was automatically generated and should not be edited.

@_spi(Internal) import ApolloAPI

/// Access level to a resource
nonisolated public enum AccessLevelEnum: String, EnumType {
  /// No access.
  case noAccess = "NO_ACCESS"
  /// Minimal access.
  case minimalAccess = "MINIMAL_ACCESS"
  /// Guest access.
  case guest = "GUEST"
  /// Planner access.
  case planner = "PLANNER"
  /// Reporter access.
  case reporter = "REPORTER"
  /// Developer access.
  case developer = "DEVELOPER"
  /// Maintainer access.
  case maintainer = "MAINTAINER"
  /// Owner access.
  case owner = "OWNER"
}
