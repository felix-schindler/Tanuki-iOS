import Foundation

public struct MyStats: Codable {
	public let closedIssuesCount: Int?
	public let totalIssuesCount: Int?
	public init(closedIssuesCount: Int?, totalIssuesCount: Int?) {
		self.closedIssuesCount = closedIssuesCount
		self.totalIssuesCount = totalIssuesCount
	}
}

public protocol Milestone {
	var iid: String { get }
	var state: GraphQLEnum<MilestoneStateEnum> { get }
	var title: String { get }
	var description: String? { get }
	var expired: Bool { get }
	var startDate: String? { get }
	var dueDate: String? { get }
	var _stats: MyStats? { get }
	var webPath: String { get }
}
