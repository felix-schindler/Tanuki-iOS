//
//  APIAnswers.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import Foundation

struct Project: Decodable {
    var id: Int
    var description: String? = ""
    var name: String
    var nameWithNamespace: String
    var defaultBranch: String? = ""     // Not all projects have a repository. (WTF!?)
    var sshUrlToRepo: String
    var httpUrlToRepo: String
    var avatarUrl: String?
    var forksCount: Int
    var starCount: Int
    var visibility: String
    var owner: UserSmall? = nil
    var issuesEnabled: Bool
    var openIssuesCount: Int? = 0
    var mergeRequestsEnabled: Bool
    var permissions: Permissions
}

struct User: Decodable {
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

struct UserSmall: Decodable, Identifiable {
    var id: Int
    var name: String
    var username: String
    var avatarUrl: String
}

struct UserStatus: Decodable {
    var emoji: String
    var message: String
}

struct Permissions: Decodable {
    var projectAccess: Access? = nil
}

struct Access: Decodable {
    var accessLevel: Int
    var notificationLevel: Int
}

struct Issue: Decodable {
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
    var references: Reference
}

struct APILabel: Decodable {
    var id: Int
    var name: String
    var color: String
    var textColor: String
}

struct Milestone: Decodable {
    var id: Int
    var iid: Int
    var title: String
    var description: String
}

struct Reference: Decodable {
    var full: String
}

struct MergeRequest: Decodable {
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

struct Event: Decodable {
    var id: Int
    var actionName: String
    var targetType: String? = ""
    var targetTitle: String? = ""
    var pushData: PushData? = nil
    var author: UserSmall
}

struct PushData: Decodable {
    var refType: String
    var ref: String
    var commitTitle: String? = nil
}

struct Discussion: Decodable {
    var id: String
    var notes: [Note]
}

struct Note: Decodable {
    var id: Int
    var body: String
    var author: UserSmall
}

struct File: Decodable {
    var filePath: String
    var content: String
}

struct Commit: Decodable {
    var id: String
    var shortId: String
    var title: String
    var message: String
    var authorName: String
    var authorEmail: String
    var authoredDate: Date
}

struct Branch: Decodable {
    var name: String
    var commit: Commit
    var merged: Bool
    var protected: Bool
    var developersCanPush: Bool
    var developersCanMerge: Bool
    var canPush: Bool
}

struct Pipeline: Decodable {
    var id: Int
    var ref: String
    var status: String
}
