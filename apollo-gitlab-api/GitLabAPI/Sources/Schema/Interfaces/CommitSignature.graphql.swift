// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension Interfaces {
  /// Represents signing information for a commit
  static let CommitSignature = ApolloAPI.Interface(
    name: "CommitSignature",
    keyFields: nil,
    implementingObjects: [
      "GpgSignature",
      "SshSignature",
      "X509Signature"
    ]
  )
}