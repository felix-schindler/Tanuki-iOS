import Foundation

public protocol Group {
	var avatarUrl: String? { get }
	var _name: String? { get }
	var fullPath: String { get }
	var visibility: String? { get }
	var groupMembersCount: Int { get }
	var projectsCount: Int { get }
	var _accessLevel: String? { get }
}
