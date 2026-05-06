import Foundation

public protocol Note {
	var system: Bool { get }
	var systemNoteIconName: String? { get }
	var body: String { get }
	var _author: MyAuthor? { get }
	var createdAt: String { get }
	var updatedAt: String { get }
	var maxAccessLevelOfAuthor: String? { get }
}
