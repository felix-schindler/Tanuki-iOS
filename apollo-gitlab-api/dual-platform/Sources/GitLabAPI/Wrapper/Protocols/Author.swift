import Foundation

public protocol Author {
    var avatarUrl: String? { get }
    var name: String { get }
    var username: String { get }
}

public struct MyAuthor: Author {
    public let avatarUrl: String?
    public let name: String
    public let username: String

    public init(avatarUrl: String?, name: String, username: String) {
        self.avatarUrl = avatarUrl
        self.name = name
        self.username = username
    }
}

public protocol HasAuthor {
    var _author: MyAuthor { get }
}

public protocol MaybeHasAuthor {
    var _author: MyAuthor? { get }
}
