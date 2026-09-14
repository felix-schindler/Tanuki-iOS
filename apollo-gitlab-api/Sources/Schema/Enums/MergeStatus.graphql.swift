// @generated
// This file was automatically generated and should not be edited.

@_spi(Internal) import ApolloAPI

/// Representation of whether a GitLab merge request can be merged.
nonisolated public enum MergeStatus: String, EnumType {
	/// Merge status has not been checked.
	case unchecked = "UNCHECKED"
	/// Currently checking for mergeability.
	case checking = "CHECKING"
	/// There are no conflicts between the source and target branches.
	case canBeMerged = "CAN_BE_MERGED"
	/// There are conflicts between the source and target branches.
	case cannotBeMerged = "CANNOT_BE_MERGED"
	/// Currently unchecked. The previous state was `CANNOT_BE_MERGED`.
	case cannotBeMergedRecheck = "CANNOT_BE_MERGED_RECHECK"
}
