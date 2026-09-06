import Foundation

public protocol SmallProject: Sendable {
	var avatarUrl: String? { get }
	var nameWithNamespace: String { get }
	var visibility: String? { get }
	var fullPath: String { get }
}
