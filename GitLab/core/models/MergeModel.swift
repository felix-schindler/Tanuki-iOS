//
//  MergeModel.swift
//  GitLab
//
//  Created by Felix Schindler on 29.11.23.
//

import Foundation

class MergeModel {
	public static func changeState(_ iid: Int, projectId: Int, state: String) async -> MergeRequest? {
		let stateChange = (state == "opened" ? "close" : "reopen")
		return await API.req(type: MergeRequest.self, method: .put, endpoint: "projects/\(projectId)/merge_requests/\(iid)", query: ["state_event": stateChange])
	}
	
	public static func deleteMR(_ iid: Int, projectId: Int) async -> Bool {
		let status = await API.delete(endpoint: "projects/\(projectId)/merge_requests/\(iid)")
		return (status.rawValue >= 200 && status.rawValue < 300)
	}
}
