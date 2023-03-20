//
//  ExploreFeedLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct AllProjectsLoader: View {
	@State var projects: [Project]? = nil
	@State var loadFailed: Bool = false
	
	@State var search: String = ""
	
	var body: some View {
		VStack {
			if (projects != nil) {
				ProjectListView(projects: projects!, updateFunction: getProjects)
					.searchable(text: $search)
					.onSubmit(of: .search) {
						Task.init {
							await getProjects()
						}
					}
			} else {
				if (loadFailed) {
					Text("Failed to load, please check your internet connection and your token")
				} else {
					Spacer()
					ProgressView("Loading")
					Spacer()
				}
			}
		}.onAppear {
			Task.init {
				projects = await getProjects()
				loadFailed = (projects == nil)
			}
		}.navigationTitle("Projects")
	}
	
	private func getProjects() async -> [Project]? {
		return await API.get(type: [Project].self, endpoint: "projects", query: [
			"search": search,
			"order_by": "last_activity_at"
		])
	}
}

struct AllProjectsLoader_Previews: PreviewProvider {
	static var previews: some View {
		AllProjectsLoader()
	}
}
