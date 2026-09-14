// @generated
// This file was automatically generated and should not be edited.

@_spi(Internal) import ApolloAPI

/// Issue type
nonisolated public enum IssueType: String, EnumType {
	/// Issue issue type
	case issue = "ISSUE"
	/// Incident issue type
	case incident = "INCIDENT"
	/// Test Case issue type
	case testCase = "TEST_CASE"
	/// Requirement issue type
	case requirement = "REQUIREMENT"
	/// Task issue type
	case task = "TASK"
	/// Ticket issue type
	case ticket = "TICKET"
	/// Objective issue type. Available only when feature flag `okrs_mvc` is enabled. Introduced in GitLab 15.6: Status: Experiment.
	///
	/// **Deprecated**: Status: Experiment. Introduced in GitLab 15.6.
	case objective = "OBJECTIVE"
	/// Key Result issue type. Available only when feature flag `okrs_mvc` is enabled. Introduced in GitLab 15.7: Status: Experiment.
	///
	/// **Deprecated**: Status: Experiment. Introduced in GitLab 15.7.
	case keyResult = "KEY_RESULT"
	/// Epic issue type. Available only when feature epics is available. Introduced in GitLab 16.7: Status: Experiment.
	///
	/// **Deprecated**: Status: Experiment. Introduced in GitLab 16.7.
	case epic = "EPIC"
}
