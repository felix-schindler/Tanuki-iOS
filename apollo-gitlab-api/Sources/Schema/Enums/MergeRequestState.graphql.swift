// @generated
// This file was automatically generated and should not be edited.

@_spi(Internal) import ApolloAPI

/// State of a GitLab merge request
nonisolated public enum MergeRequestState: String, EnumType {
	/// Merge request has been merged.
	case merged = "merged"
	/// Opened merge request.
	case opened = "opened"
	/// In closed state.
	case closed = "closed"
	/// Discussion has been locked.
	case locked = "locked"
	/// All available.
	case all = "all"
}
