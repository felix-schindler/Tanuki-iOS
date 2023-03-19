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

	var body: some View {
		VStack {
			if (members != nil) {
				UserSmallListView(users: members!, updateFunction: getMembers)
			} else if (loadFailed) {
				Text("Failed to load, please check your internet connection and your token")
			} else {
				Spacer()
				ProgressView("Loading")
				Spacer()
			}
		}.onAppear {
			Task.init {
				members = await getMembers()
				loadFailed = (members == nil)
			}
		}
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
