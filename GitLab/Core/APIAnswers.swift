//
//  APIAnswers.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import Foundation

struct Project: Decodable {
    var id: Int
    var description: String
    var name: String
    var nameWithNamespace: String
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
    var message: String
}

struct Issue: Decodable {
    var id: Int
    var iid: Int
    var title: String
    var description: String
    var assignees: [UserSmall]?
    var author: UserSmall
    var labels: [String]?
    var references: Reference
}

struct Reference: Decodable {
    var full: String
}

struct MergeRequest: Decodable {
    var id: Int
    var iid: Int
    var title: String
    var description: String
    var userNotesCount: Int
    var upvotes: Int
    var downvotes: Int
    var author: UserSmall
    var assignees: [UserSmall]?
    var reviewers: [UserSmall]?
    var labels: [String]?
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
