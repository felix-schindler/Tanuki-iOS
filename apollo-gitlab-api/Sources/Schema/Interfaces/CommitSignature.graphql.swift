// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension Interfaces {
	/// Represents signing information for a commit
	public nonisolated static let CommitSignature = ApolloAPI.Interface(
		name: "CommitSignature",
		keyFields: nil,
		implementingObjects: [
			"GpgSignature",
			"SshSignature",
			"X509Signature",
		]
	)
}
