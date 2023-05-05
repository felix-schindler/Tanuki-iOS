//
//  APIAnswers.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import Foundation

struct Project: Codable {
	let id: Int
	let description: String?
	let name: String
	let nameWithNamespace: String
	let pathWithNamespace: String
	let defaultBranch: String?     // Not all projects have a repository. Maybe they are just issue trackers, wikis, ...
	let tagList: [String]
	let webUrl: String
	let readmeUrl: String?
	let avatarUrl: String?
	let forksCount: Int?           // Not all projects have a repository. Maybe they are just issue trackers, wikis, ...
	var starCount: Int
	let namespace: Namespace
	let visibility: String
	let owner: UserSmall?
	let issuesEnabled: Bool
	let openIssuesCount: Int?
	let mergeRequestsEnabled: Bool
	let permissions: Permissions?
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
	let followers: Int?
	let following: Int?
	let localTime: String?
	let isFollowed: Bool?
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
	let avatarUrl: String?
}

struct Permissions: Codable {
	let projectAccess: Access?
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
	let dueDate: String?
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
	let startDate: String?
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
	let targetType: String?
	let targetTitle: String?
	let createdAt: Date
	let pushData: PushData?
	let author: UserSmall
}

struct PushData: Codable {
	let refType: String
	let ref: String
	let commitTitle: String?
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
	let avatarUrl: String?
	let projects: [Project]
	let createdAt: Date
}

struct SmallGroup: Codable {
	let id: Int
	let name: String
	let description: String?
	let visibility: String
	let avatarUrl: String?
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

struct Tag: Codable {
	let name: String
	let message: String	// Empty string if not set
	let target: String
	let commit: Commit
	let protected: Bool
}

struct Release: Codable {
	let name: String
	let tagName: String
	let description: String	// Empty string if not set
	let releasedAt: Date
	let commit: Commit
	let assets: Assets?
}

struct Assets: Codable {
	let count: Int
	let sources: [Source]
}

struct Source: Codable {
	let format: String
	let url: String
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
