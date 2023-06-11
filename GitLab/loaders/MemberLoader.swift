//
//  ProjectMemberLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 19.03.23.
//

import SwiftUI

struct MemberLoader: View {
	/// Project ID
	@State var id: Int
	/// Group ID
	@State var groupId: Int

	@State var members: [UserSmall]? = nil
	@State var loadFailed: Bool = false
	
	@State var showNewMember = false

	init(id: Int = 0, groupId: Int = 0) {
		/* if (id == 0 && groupId == 0) {
			fatalError("Either project or group id need to be set!")
		} */
		
		self.id = id
		self.groupId = groupId
	}
	
	var body: some View {
		List {
			if (members != nil) {
				UserSmallListView(users: members!)
			} else if (loadFailed) {
				Text("Failed to load, please check your internet connection and your token")
			} else {
				ProgressView()
			}
		}.onAppear {
			Task {
				members = await getMembers()
				loadFailed = (members == nil)
			}
		}.refreshable {
			if let temp = await getMembers() {
				members = temp
			}
		}.toolbar {
			Button (action: { showNewMember = true }) {
				Image(systemName: "person.badge.plus")
			}
		}.sheet(isPresented: $showNewMember) {
			NewMember(id: id, groupId: groupId)
		}.navigationTitle("Members")
	}
	
	private func getMembers() async -> [UserSmall]? {
		var endpoint = ""
		if (id != 0) {
			endpoint = "projects/\(id)/members"
		} else if (groupId != 0) {
			endpoint = "groups/\(groupId)/members"
		} else {
			// TODO: Remove debug message after testing
			print("[DEBUG] Loading all users")
			endpoint = "users"
		}
		return await API.get(type: [UserSmall].self, endpoint: endpoint)
	}
}

struct MemberLoader_Previews: PreviewProvider {
	static var previews: some View {
		MemberLoader(id: 33025310)
	}
}
