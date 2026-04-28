//
//  GraphTypes.swift
//  Tanuki
//
//  Created by Felix Schindler on 20.09.25.
//

import GitLabAPI

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
