import Foundation

public protocol Member {
	var id: String { get }
	var createdAt: String? { get }
	var expiresAt: String? { get }
	var _accessLevel: String? { get }
	var _user: MyAuthor? { get }
	var _createdBy: MyAuthor? { get }
}
