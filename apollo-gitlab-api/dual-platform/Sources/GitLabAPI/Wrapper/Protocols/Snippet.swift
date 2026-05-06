import Foundation

public protocol Snippet {
    var id: String { get }
    var title: String { get }
    var _author: MyAuthor? { get }
    var createdAt: String { get }
    var webUrl: String { get }
    var visibilityLevelRawValue: String { get }
}
