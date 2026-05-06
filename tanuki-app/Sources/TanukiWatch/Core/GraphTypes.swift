//
//  GraphTypes.swift
//  Tanuki
//
//  Created by Felix Schindler on 20.09.25.
//

import IOSGitLabAPI

// MARK: - Global
struct MyAuthor: Codable {
	let avatarUrl: String?
	let name: String
	let username: String
}

// MARK: - Issues
protocol SmallIssue {
	var iid: String { get }
	var title: String { get }
	var reference: String { get }
	var state: GraphQLEnum<GitLabAPI.IssueState> { get }
	var upvotes: Int { get }
	var downvotes: Int { get }
	var userNotesCount: Int { get }
	var _author: MyAuthor { get }
	var createdAt: String { get }
	var webUrl: String { get }
}

protocol IssueProjectMembership {
	var fullPath: String? { get }
	var _issues: [SmallIssue?]? { get }
}

extension CurrentUserIssuesQuery.Data.CurrentUser.ProjectMemberships.Node.Project.Issues.Node: SmallIssue {
	var _author: MyAuthor {
		return MyAuthor(avatarUrl: author.avatarUrl, name: author.name, username: author.username)
	}
}

extension CurrentUserIssuesQuery.Data.CurrentUser.ProjectMemberships.Node: IssueProjectMembership {
	var fullPath: String? {
		return project?.fullPath
	}

	var _issues: [SmallIssue?]? {
		return project?.issues?.nodes
	}
}

// MARK: - Merge Requests
protocol SmallMergeRequest {
	var iid: String { get }
	var title: String { get }
	var reference: String { get }
	var state: GraphQLEnum<GitLabAPI.MergeRequestState> { get }
	var upvotes: Int { get }
	var downvotes: Int { get }
	var userNotesCount: Int? { get }
	var _author: MyAuthor? { get }
	var createdAt: String { get }
	var webUrl: String? { get }
	var _project: MergeRequestProject { get }
}

protocol MergeRequestProject {
	var fullPath: String { get }
}

extension UserAssignedMergeRequestsQuery.Data.CurrentUser.AssignedMergeRequests.Node: SmallMergeRequest {
	var _author: MyAuthor? {
		guard let author else { return nil }
		return MyAuthor(avatarUrl: author.avatarUrl, name: author.name, username: author.username)
	}

	var _project: MergeRequestProject {
		return project
	}
}

extension UserAuthoredMergeRequestsQuery.Data.CurrentUser.AuthoredMergeRequests.Node: SmallMergeRequest {
	var _author: MyAuthor? {
		guard let author else { return nil }
		return MyAuthor(avatarUrl: author.avatarUrl, name: author.name, username: author.username)
	}

	var _project: MergeRequestProject {
		return project
	}
}

extension UserReviewRequestedMergeRequestsQuery.Data.CurrentUser.ReviewRequestedMergeRequests.Node: SmallMergeRequest {
	var _author: MyAuthor? {
		guard let author else { return nil }
		return MyAuthor(avatarUrl: author.avatarUrl, name: author.name, username: author.username)
	}

	var _project: MergeRequestProject {
		return project
	}
}

extension UserAssignedMergeRequestsQuery.Data.CurrentUser.AssignedMergeRequests.Node.Project: MergeRequestProject {}

extension UserAuthoredMergeRequestsQuery.Data.CurrentUser.AuthoredMergeRequests.Node.Project: MergeRequestProject {}

extension UserReviewRequestedMergeRequestsQuery.Data.CurrentUser.ReviewRequestedMergeRequests.Node.Project: MergeRequestProject {}
