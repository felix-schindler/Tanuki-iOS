import Foundation

public protocol Release: Sendable {
    var _author: MyAuthor? { get }
}
