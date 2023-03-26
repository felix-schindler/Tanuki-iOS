//
//  APIAnswers.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import Foundation

struct Project: Codable {
	let id: Int
	var description: String? = nil
	let name: String
	let nameWithNamespace: String
	let pathWithNamespace: String
	var defaultBranch: String? = nil     // Not all projects have a repository. Maybe they are just issue trackers, wikis, ...
	var tagList = [String]()
	let webUrl: String
	var readmeUrl: String? = nil
	let avatarUrl: String?
	var forksCount: Int? = nil           // Not all projects have a repository. Maybe they are just issue trackers, wikis, ...
	var starCount: Int
	let namespace: Namespace
	let visibility: String
	var owner: UserSmall? = nil
	let issuesEnabled: Bool
	var openIssuesCount: Int? = 0
	let mergeRequestsEnabled: Bool
	var permissions: Permissions? = nil
}

struct User: Codable {
	let id: Int
	let username: String
	let name: String
	let state: String
	let avatarUrl: String
	let webUrl: String
	let createdAt: Date
	let bio: String
	let bot: Bool
	let location: String?
	let publicEmail: String?
	let skype: String
	let linkedin: String
	let twitter: String
	let discord: String
	let websiteUrl: String
	let organization: String
	let jobTitle: String
	let pronouns: String?
	let workInformation: String?
	let followers: Int
	let following: Int
	let localTime: String?
	let isFollowed: Bool
}

struct UserSmall: Codable {
	let id: Int
	let name: String
	let username: String
	let avatarUrl: String
}

struct UserStatus: Codable {
	let emoji: String?
	let message: String?
}

struct Namespace: Codable {
	let name: String
	let path: String
	var avatarUrl: String? = nil
}

struct Permissions: Codable {
	var projectAccess: Access? = nil
}

struct Access: Codable {
	let accessLevel: Int
	let notificationLevel: Int
}

struct Issue: Codable {
	let id: Int
	let iid: Int
	let projectId: Int
	let title: String
	let description: String
	let createdAt: Date
	let state: String
	let labels: [APILabel]?
	let milestone: Milestone?
	let assignees: [UserSmall]?
	let author: UserSmall
	let type: String
	let userNotesCount: Int
	let upvotes: Int
	let downvotes: Int
	var dueDate: String? = nil
	let confidential: Bool
	let webUrl: String
	let references: Reference
}

struct APILabel: Codable {
	let id: Int
	let name: String
	let description: String?
	let color: String
	let textColor: String
}

struct Milestone: Codable {
	let id: Int
	let iid: Int
	let title: String
	let description: String
	let state: String
	let dueDate: String?
	let webUrl: String
}

struct Reference: Codable {
	let short: String
	let full: String
}

struct MergeRequest: Codable {
	let id: Int
	let iid: Int
	let projectId: Int
	let title: String
	let description: String
	let state: String
	let createdAt: Date
	let mergedBy: UserSmall?
	let mergeUser: UserSmall?
	let mergedAt: Date?
	let closedBy: UserSmall?
	let closedAt: Date?
	let targetBranch: String
	let sourceBranch: String
	let userNotesCount: Int
	let upvotes: Int
	let downvotes: Int
	let author: UserSmall
	let assignees: [UserSmall]?
	let reviewers: [UserSmall]?
	let labels: [APILabel]?
	let draft: Bool
	let workInProgress: Bool
	let milestone: Milestone?
	let mergeWhenPipelineSucceeds: Bool
	let mergeStatus: String
	let detailedMergeStatus: String
	let references: Reference
	let webUrl: String
	let pipeline: Pipeline?
	let mergeError: String?
}

struct Event: Codable {
	let id: Int
	let actionName: String
	let targetIid: Int?
	var targetType: String? = ""
	var targetTitle: String? = ""
	let createdAt: Date
	var pushData: PushData? = nil
	let author: UserSmall
}

struct PushData: Codable {
	let refType: String
	let ref: String
	var commitTitle: String? = nil
}

struct Note: Codable {
	let id: Int
	let body: String
	let author: UserSmall
	let createdAt: Date
}

struct Group: Codable {
	let id: Int
	let webUrl: String
	let name: String
	let description: String
	let visibility: String
	var avatarUrl: String? = nil
	let projects: [Project]
}

struct SmallGroup: Codable {
	let id: Int
	let name: String
	var description: String? = nil
	let visibility: String
	var avatarUrl: String? = nil
}

struct File: Codable {
	let filePath: String
	let content: String
}

struct TreeFile: Codable {
	let id: String
	let name: String
	let type: String
	let path: String
}

struct Commit: Codable {
	let id: String
	let shortId: String
	let title: String
	let message: String
	let authorName: String
	let authorEmail: String
	let authoredDate: Date
}

struct Branch: Codable {
	let name: String
	let commit: Commit
	let merged: Bool
	let protected: Bool
	let developersCanPush: Bool
	let developersCanMerge: Bool
	let canPush: Bool
}

struct Pipeline: Codable {
	let id: Int
	let ref: String
	let status: String
	let source: String
	let createdAt: Date
}

struct ToggleStar: Codable {
	let starCount: Int
}
