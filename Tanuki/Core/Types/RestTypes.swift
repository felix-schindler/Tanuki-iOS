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
}

// MARK: - Users
struct UserSmall: Codable {
	let id: Int
}

// MARK: - Releases
struct RestAPIRelease: Codable {
	let name: String
}

// MARK: - Milestones
struct RestAPIMilestone: Codable {
	let iid: Int
}

// MARK: - Issues
struct RestAPIIssue: Codable {
	let iid: Int
}
