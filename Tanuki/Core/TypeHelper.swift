//
//  TypeHelper.swift
//  Tanuki
//
//  Created by Felix Schindler on 28.02.24.
//

import Foundation
import GitLabAPI

// MARK: - MERGE REQUESTS
struct SmallAuthor {
	var name: String
}

struct ProjectPath {
	var fullPath: String
}

protocol SmallMergeRequest {
	var iid: String { get }
	var title: String { get }
	var reference: String { get }
	var state: GraphQLEnum<GitLabAPI.MergeRequestState> { get }
	var upvotes: Int { get }
	var downvotes: Int { get }
	var userNotesCount: Int? { get }
	var _author: SmallAuthor? { get }
	var createdAt: String { get }
	var webUrl: String? { get }
}

extension ProjectMergeRequestsQuery.Data.Project.MergeRequests.Node: SmallMergeRequest {
	var _author: SmallAuthor? {
		guard let authorData = author else { return nil }
		return SmallAuthor(name: authorData.name)
	}
}

protocol UserSmallMergeRequest: SmallMergeRequest {
	var _project: ProjectPath { get }
}

extension UserAssignedMergeRequestsQuery.Data.CurrentUser.AssignedMergeRequests.Node: UserSmallMergeRequest {
	var _project: ProjectPath {
		return ProjectPath(fullPath: project.fullPath)
	}
	
	var _author: SmallAuthor? {
		guard let authorData = author else { return nil }
		return SmallAuthor(name: authorData.name)
	}
}
extension UserAuthoredMergeRequestsQuery.Data.CurrentUser.AuthoredMergeRequests.Node: UserSmallMergeRequest {
	var _project: ProjectPath {
		return ProjectPath(fullPath: project.fullPath)
	}

	var _author: SmallAuthor? {
		guard let authorData = author else { return nil }
		return SmallAuthor(name: authorData.name)
	}
}
extension UserReviewRequestedMergeRequestsQuery.Data.CurrentUser.ReviewRequestedMergeRequests.Node: UserSmallMergeRequest {
	var _project: ProjectPath {
		return ProjectPath(fullPath: project.fullPath)
	}

	var _author: SmallAuthor? {
		guard let authorData = author else { return nil }
		return SmallAuthor(name: authorData.name)
	}
}

// MARK: - NOTES
struct _Author {
	var avatarUrl: String?
	var username: String
}

protocol Note {
	var system: Bool { get }
	var systemNoteIconName: String? { get }
	var body: String { get }
	var _author: _Author? { get }
	var createdAt: String { get }
	var updatedAt: String { get }
	var maxAccessLevelOfAuthor: String? { get }
}

extension IssueQuery.Data.Project.Issue.Notes.Node: Note {
	var _author: _Author? {
		guard let authorData = author else { return nil }
		return _Author(avatarUrl: authorData.avatarUrl, username: authorData.username)
	}
}

extension MergeRequestQuery.Data.Project.MergeRequest.Notes.Node: Note {
	var _author: _Author? {
		guard let authorData = author else { return nil }
		return _Author(avatarUrl: authorData.avatarUrl, username: authorData.username)
	}
}

extension SnippetQuery.Data.Snippets.Node.Notes.Node: Note {
	var _author: _Author? {
		guard let authorData = author else { return nil }
		return _Author(avatarUrl: authorData.avatarUrl, username: authorData.username)
	}
}


// MARK: - PROJECTS
extension UserMembershipProjectsQuery.Data.CurrentUser.ProjectMemberships.Node.Project: SmallProject {
}

extension StarredProjectsQuery.Data.CurrentUser.StarredProjects.Node: SmallProject {
}
