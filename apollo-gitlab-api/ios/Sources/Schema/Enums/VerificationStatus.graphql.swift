// @generated
// This file was automatically generated and should not be edited.

@_spi(Internal) import ApolloAPI

/// Verification status of a GPG, X.509 or SSH signature for a commit.
nonisolated public enum VerificationStatus: String, EnumType {
  /// unverified verification status.
  case unverified = "UNVERIFIED"
  /// verified verification status.
  case verified = "VERIFIED"
  /// same_user_different_email verification status.
  case sameUserDifferentEmail = "SAME_USER_DIFFERENT_EMAIL"
  /// other_user verification status.
  case otherUser = "OTHER_USER"
  /// unverified_key verification status.
  case unverifiedKey = "UNVERIFIED_KEY"
  /// unknown_key verification status.
  case unknownKey = "UNKNOWN_KEY"
  /// multiple_signatures verification status.
  case multipleSignatures = "MULTIPLE_SIGNATURES"
  /// revoked_key verification status.
  case revokedKey = "REVOKED_KEY"
  /// verified_system verification status.
  case verifiedSystem = "VERIFIED_SYSTEM"
  /// unverified_author_email verification status.
  case unverifiedAuthorEmail = "UNVERIFIED_AUTHOR_EMAIL"
  /// expired_key verification status.
  case expiredKey = "EXPIRED_KEY"
  /// verified_ca verification status.
  case verifiedCa = "VERIFIED_CA"
}
