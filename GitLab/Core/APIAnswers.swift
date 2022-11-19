//
//  APIAnswers.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import Foundation

struct Project: Codable {
    var id: Int
    var description: String? = nil
    var name: String
    var nameWithNamespace: String
    var pathWithNamespace: String
    var defaultBranch: String? = nil     // Not all projects have a repository. Maybe they are just issue trackers, wikis, ...
    var tagList = [String]()
    var avatarUrl: String?
    var forksCount: Int
    var starCount: Int
    var namespace: Namespace
    var visibility: String
    var owner: UserSmall? = nil
    var issuesEnabled: Bool
    var openIssuesCount: Int? = 0
    var mergeRequestsEnabled: Bool
    var permissions: Permissions
}

struct User: Codable {
    var id: Int
    var name: String
    var username: String
    var avatarUrl: String
    var bio: String
    var location: String
    var publicEmail: String
    var websiteUrl: String
    var followers: Int
    var following: Int
}

struct UserSmall: Codable {
    var id: Int
    var name: String
    var username: String
    var avatarUrl: String
}

struct UserStatus: Codable {
    var emoji: String
    var message: String
}

struct Namespace: Codable {
    var name: String
    var path: String
    var avatarUrl: String? = nil
}

struct Permissions: Codable {
    var projectAccess: Access? = nil
}

struct Access: Codable {
    var accessLevel: Int
    var notificationLevel: Int
}

struct Issue: Codable {
    var id: Int
    var iid: Int
    var projectId: Int
    var title: String
    var description: String
    var createdAt: Date
    var state: String
    var labels: [APILabel]?
    var milestone: Milestone?
    var assignees: [UserSmall]?
    var author: UserSmall
    var type: String
    var userNotesCount: Int
    var confidential: Bool
    var references: Reference
}

struct APILabel: Codable {
    var id: Int
    var name: String
    var color: String
    var textColor: String
}

struct Milestone: Codable {
    var id: Int
    var iid: Int
    var title: String
    var description: String
}

struct Reference: Codable {
    var short: String
    var full: String
}

struct MergeRequest: Codable {
    var id: Int
    var iid: Int
    var projectId: Int
    var title: String
    var description: String
    var userNotesCount: Int
    var upvotes: Int
    var downvotes: Int
    var author: UserSmall
    var assignees: [UserSmall]?
    var reviewers: [UserSmall]?
    var labels: [APILabel]?
    var references: Reference
}

struct Event: Codable {
    var id: Int
    var actionName: String
    var targetIid: Int?
    var targetType: String? = ""
    var targetTitle: String? = ""
    var createdAt: Date
    var pushData: PushData? = nil
    var author: UserSmall
}

struct PushData: Codable {
    var refType: String
    var ref: String
    var commitTitle: String? = nil
}

struct Note: Codable {
    var id: Int
    var body: String
    var author: UserSmall
    var createdAt: Date
}

struct Group: Codable {
    var id: Int
    var name: String
    var description: String? = nil
    var visibility: String
    var avatarUrl: String? = nil
}

struct File: Codable {
    var filePath: String
    var content: String
}

struct TreeFile: Codable {
    var id: String
    var name: String
    var type: String
    var path: String
}

struct Commit: Codable {
    var id: String
    var shortId: String
    var title: String
    var message: String
    var authorName: String
    var authorEmail: String
    var authoredDate: Date
}

struct Branch: Codable {
    var name: String
    var commit: Commit
    var merged: Bool
    var protected: Bool
    var developersCanPush: Bool
    var developersCanMerge: Bool
    var canPush: Bool
}

struct Pipeline: Codable {
    var id: Int
    var ref: String
    var status: String
    var source: String
    var createdAt: Date
}

struct ToggleStar: Codable {
    var starCount: Int
}

struct MarkdownHTML: Codable {
    var html: String
}
