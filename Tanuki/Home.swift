//
//  Home.swift
//  Tanuki
//
//  Created by Felix Schindler on 27.02.24.
//

import SwiftUI
import GitLabAPI

struct Home: View {
	@State
	private var starredProjects: [GitLabAPI.StarredProjectsQuery.Data.CurrentUser.StarredProjects.Node?]? = nil
	
	@State
	private var loadFailed = false
	
	private func loadStarredProjects() {
		Network.shared.apollo.fetch(query: StarredProjectsQuery()) { result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting projects...")
				starredProjects = graphQLResult.data?.currentUser?.starredProjects?.nodes ?? []
			case .failure(let error):
				print("Failure! Error: \(error)")
				loadFailed = true
			}
		}
	}
	
	public var body: some View {
		List {
			Section("Your work") {
				NavigationLink(destination: Issue(
					fullPath: "gitlab-org/gitlab",
					iid: "15603"
				), label: {
					Label(title: {
						Text("Issues")
					}, icon: {
						Image(systemName: "smallcircle.circle")
							.foregroundStyle(.green)
					})
				})
				NavigationLink(destination: Issue(
					fullPath: "gitlab-org/gitlab",
					iid: "15603"
				), label: {
					Label(title: {
						Text("Merge Requests")
					}, icon: {
						Image(systemName: "arrow.triangle.pull")
							.foregroundStyle(.blue)
					})
				})
			}

			Section("Starred projects") {
				if (starredProjects != nil) {
					if (starredProjects!.isEmpty) {
						VStack(alignment: .center) {
							Text("There are no starred projects")
						}.frame(maxWidth: .infinity, minHeight: 100)
					} else {
						ForEach(starredProjects!, id: \.self) { maybeProject in
							if let project = maybeProject {
								NavigationLink(destination: Project(fullPath: project.fullPath), label: {
									HStack {
										if let url = URL.fromAvatar(project.avatarUrl) {
											AvatarImage(url, size: .small)
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
			}
		}.onAppear {
			loadStarredProjects()
		}.refreshable {
			loadStarredProjects()
		}
		.listStyle(.sidebar)
		.headerProminence(.increased)
		.navigationTitle("Home")
	}
}

#Preview {
	Home()
}
