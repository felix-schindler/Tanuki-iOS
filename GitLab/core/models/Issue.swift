//
//  Issue.swift
//  GitLab
//
//  Created by Felix Schindler on 23.03.23.
//

import Foundation

class IssueModel {
	public static func changeState(_ iid: Int, projectId: Int, state: String) async -> Issue? {
		let stateChange = (state == "opened" ? "close" : "reopen")
		return await API.req(type: Issue.self, method: .put, endpoint: "projects/\(projectId)/issues/\(iid)", query: ["state_event": stateChange])
	}
	
	public static func deleteIssue(_ iid: Int, projectId: Int) async -> Bool {
		let status = await API.delete(endpoint: "projects/\(projectId)/issues/\(iid)")
		return (status.rawValue >= 200 && status.rawValue < 300)
	}
}
