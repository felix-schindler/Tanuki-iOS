import Foundation

public protocol Todo: Sendable {
	var id: String { get }
	var body: String { get }
	var _groupPath: String? { get }
	var state: TodoStateEnum { get }
	var action: TodoActionEnum { get }
	var _author: MyAuthor { get }
	var _webUrl: String? { get }
	var _project: SmallProjectStruct? { get }
	var createdAt: String { get }
	var targetType: TodoTargetEnum { get }
}
