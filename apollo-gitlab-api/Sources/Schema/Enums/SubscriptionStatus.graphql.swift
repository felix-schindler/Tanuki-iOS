// @generated
// This file was automatically generated and should not be edited.

@_spi(Internal) import ApolloAPI

/// Status of the subscription to an issuable.
nonisolated public enum SubscriptionStatus: String, EnumType {
	/// User is explicitly subscribed to the issuable.
	case explicitlySubscribed = "EXPLICITLY_SUBSCRIBED"
	/// User is explicitly unsubscribed from the issuable.
	case explicitlyUnsubscribed = "EXPLICITLY_UNSUBSCRIBED"
}
