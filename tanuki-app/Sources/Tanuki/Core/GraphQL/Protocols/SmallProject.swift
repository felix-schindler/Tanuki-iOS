import Foundation

public protocol SmallProject {
	var avatarUrl: String? { get }
	var nameWithNamespace: String { get }
	var visibility: String? { get }
	var fullPath: String { get }
	var archived: Bool? { get }
}

public struct SmallProjectStruct: SmallProject {
	public let avatarUrl: String?
	public let nameWithNamespace: String
	public let visibility: String?
	public let fullPath: String
	public let archived: Bool?

	public init(avatarUrl: String?, nameWithNamespace: String, visibility: String?, fullPath: String, archived: Bool? = nil) {
		self.avatarUrl = avatarUrl
		self.nameWithNamespace = nameWithNamespace
		self.visibility = visibility
		self.fullPath = fullPath
		self.archived = archived
	}
}
