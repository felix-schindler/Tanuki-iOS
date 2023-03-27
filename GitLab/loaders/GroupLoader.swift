//
//  GroupLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 08.03.23.
//

import SwiftUI

struct GroupLoader: View {
	@State var id: Int
	
	@State var group: Group? = nil
	@State var loadFailed: Bool = false
	
	var body: some View {
		VStack {
			if (group != nil) {
				GroupView(group: group!, updateFunction: getGroup)
			} else if (loadFailed) {
				Text("Failed to load, please check your internet connection and your token")
			} else {
				Spacer()
				ProgressView("Loading")
				Spacer()
			}
		}.onAppear {
			Task {
				group = await getGroup()
				loadFailed = (group == nil)
			}
		}
	}
	
	private func getGroup() async -> Group? {
		return await API.get(type: Group.self, endpoint: "groups/\(id)")
	}
}

struct GroupLoader_Previews: PreviewProvider {
	static var previews: some View {
		GroupLoader(id: 59430464)
	}
}
