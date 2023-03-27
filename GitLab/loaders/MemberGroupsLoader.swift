//
//  MemberGroupsLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 24.01.22.
//

import SwiftUI

struct MemberGroupsLoader: View {
	@State var groups: [SmallGroup]? = nil
	@State var loadFailed: Bool = false
	
	var body: some View {
		VStack {
			if (groups != nil) {
				GroupListView(groups: groups!, updateFunction: getGroups)
			} else {
				if (loadFailed) {
					Text("Failed to load, please check your internet connection and your token")
				} else {
					VStack {
						Spacer()
						ProgressView("Loading")
						Spacer()
					}
				}
			}
		}.onAppear {
			Task {
				groups = await getGroups()
				loadFailed = (groups == nil)
			}
		}.navigationTitle("Groups")
	}
	
	private func getGroups() async -> [SmallGroup]? {
		return await API.get(type: [SmallGroup].self, endpoint: "groups")
	}
}

struct MemberGroupsLoader_Previews: PreviewProvider {
	static var previews: some View {
		MemberGroupsLoader()
	}
}
