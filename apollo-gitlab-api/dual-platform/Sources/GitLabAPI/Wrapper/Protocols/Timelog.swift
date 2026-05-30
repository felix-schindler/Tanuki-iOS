import Foundation

public struct T_Project: Codable, Hashable, Sendable {
    public let fullPath: String
    public let nameWithNamespace: String
    public init(fullPath: String, nameWithNamespace: String) {
        self.fullPath = fullPath
        self.nameWithNamespace = nameWithNamespace
    }
}

public struct T_Issue: Codable, Hashable, Sendable {
    public let iid: String
    public init(iid: String) { self.iid = iid }
}

public struct T_MR: Codable, Hashable, Sendable {
    public let iid: String
    public init(iid: String) { self.iid = iid }
}

public protocol Timelog: Sendable {
    var id: String { get }
    var _user: MyAuthor { get }
    var spentAt: String? { get }
    var summary: String? { get }
    var timeSpent: Int { get }
    var _project: T_Project { get }
    var _issue: T_Issue? { get }
    var _mergeRequest: T_MR? { get }
}
