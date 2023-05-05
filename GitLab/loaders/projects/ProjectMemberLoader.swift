//
//  ProjectMemberLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 19.03.23.
//

import SwiftUI

struct ProjectMemberLoader: View {
	/// Project ID
	@State var id: Int

	@State var members: [UserSmall]? = nil
	@State var loadFailed: Bool = false
	
	@State var showNewMember = false

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
			let temp = await getMembers()
			if (temp != nil) {
				members = temp!
			}
		}.toolbar {
			Button (action: { showNewMember = true }) {
				Image(systemName: "plus.circle")
			}
		}.sheet(isPresented: $showNewMember) {
			NewMember(id: id)
		}.navigationTitle("Members")
	}
	
	private func getMembers() async -> [UserSmall]? {
		return await API.get(type: [UserSmall].self, endpoint: "projects/\(id)/members")
	}
}

struct ProjectMemberLoader_Previews: PreviewProvider {
	static var previews: some View {
		ProjectMemberLoader(id: 33025310)
	}
}
