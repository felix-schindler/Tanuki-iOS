//
//  ContentView.swift
//  Tanuki
//
//  Created by Felix Schindler on 26.02.24.
//

import SwiftUI
import GitLabAPI

struct StarredProjects: View {
	@State
	private var projects: [GitLabAPI.StarredProjectsQuery.Data.CurrentUser.StarredProjects.Node?]? = nil
	
	@State
	private var loadFailed = false
	
	private func loadStarredProjects() {
		Network.shared.apollo.fetch(query: StarredProjectsQuery()) { result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting projects...")
				projects = graphQLResult.data?.currentUser?.starredProjects?.nodes ?? []
			case .failure(let error):
				print("Failure! Error: \(error)")
				loadFailed = true
			}
		}
	}
	
	public var body: some View {
		List {
			if let projects = self.projects {
				if (projects.isEmpty) {
					VStack(alignment: .center) {
						Text("There are no starred projects")
					}.frame(maxWidth: .infinity, minHeight: 100)
				} else {
					ForEach(projects, id: \.self) { maybeProject in
						if let project = maybeProject {
							NavigationLink(destination: Project(fullPath: project.fullPath), label: {
								HStack {
									if let url = URL.fromAvatar(project.avatarUrl) {
										AvatarImage(url: url, size: .small)
									}
									Text(project.nameWithNamespace)
									Spacer()
									if let visibility = project.visibility {
										VisibilityIcon(visibility)
									}
								}
							})
						}
					}
				}
			} else if (loadFailed) {
				VStack(alignment: .center) {
					Text(LOAD_FAILED)
				}.frame(maxWidth: .infinity, minHeight: 100)
			} else {
				VStack(alignment: .center) {
					ProgressView("Loading starred projects...")
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadStarredProjects()
		}.refreshable {
			loadStarredProjects()
		}.navigationTitle("Starred Projects")
	}
}

#Preview {
	NavigationStack {
		StarredProjects()
	}
}
