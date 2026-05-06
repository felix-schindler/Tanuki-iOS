import Foundation

public protocol User {
	var id: String { get }
	var avatarUrl: String? { get }
	var name: String { get }
	var username: String { get }
	var bot: Bool { get }
	var pronouns: String? { get }
	var state: GraphQLEnum<UserState> { get }
	var _status: UserStatus? { get }
	var bio: String? { get }
	var location: String? { get }
	var jobTitle: String? { get }
	var organization: String? { get }
	var discord: String? { get }
	var twitter: String? { get }
	var linkedin: String? { get }
	var publicEmail: String? { get }
	var groupCount: Int? { get }
	var createdAt: String? { get }
	var webUrl: String { get }
}
