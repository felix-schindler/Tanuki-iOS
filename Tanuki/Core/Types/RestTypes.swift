//
//  RestTypes.swift
//  Tanuki
//
//  Created by Felix Schindler on 03.03.24.
//

import Foundation

// MARK: - Events
struct Event: Codable {
	let id: Int
	let projectId: Int
	let actionName: String
	let targetIid: Int?
	let targetType: String?
	let targetTitle: String?
	let createdAt: Date
	let pushData: PushData?
	let author: MyAuthor
}

struct PushData: Codable {
	let refType: String
	let ref: String
	let commitTitle: String?
}

// MARK: - Labels
struct RestAPILabel: Codable {
	let id: Int
	let name: String
	let description: String?
	let color: String
	let textColor: String
}

// MARK: - Users
struct UserSmall: Codable {
	let id: Int
	let name: String
	let username: String
	let avatarUrl: String
}

// MARK: - Releases
struct RestAPIRelease: Codable {
	let name: String
	let tagName: String
	let description: String  // Empty string if not set
	let releasedAt: Date
	let author: UserSmall
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

// MARK: - Milestones
struct RestAPIMilestone: Codable {
	let id: Int
	let iid: Int
	let title: String
	let description: String
	let state: String
	let startDate: String?
	let dueDate: String?
	let expired: Bool
	let webUrl: String
}
