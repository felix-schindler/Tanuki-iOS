import Foundation

public protocol Todo {
    var id: String { get }
    var body: String { get }
    var _groupPath: String? { get }
    var state: GraphQLEnum<TodoStateEnum> { get }
    var action: GraphQLEnum<TodoActionEnum> { get }
    var _author: MyAuthor { get }
    var _webUrl: String? { get }
    var _project: SmallProject? { get }
    var createdAt: String { get }
    var targetType: GraphQLEnum<TodoTargetEnum> { get }
}
