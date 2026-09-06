import Foundation

public protocol Release: Sendable {
	var _author: MyAuthor? { get }
	var id: String? { get }
	var name: String? { get }
	var description: String? { get }
	var tagName: String? { get }
	var releasedAt: String? { get }
	var commit: ReleaseCommitStruct? { get }
	var milestones: ReleaseMilestoneConnectionStruct? { get }
	var assets: ReleaseAssetConnectionStruct? { get }
}
