//
//  UserStarredProjectsLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 03.03.24.
//

import GitLabAPI
import SwiftUI

struct UserStarredProjectsLoader: View {
	private let username: String

	@State
	private var projects: [UserStarredProjectsQuery.Data.User.StarredProjects.Node?]?

	@State
	private var loadFailed = false

	init(username: String) {
		self.username = username
	}

	private func loadStarredProjects() {
		Network.shared.apollo.fetch(
			query: UserStarredProjectsQuery(username: self.username)
		) {
			result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting projects...")
				projects = graphQLResult.data?.user?.starredProjects?.nodes
			case .failure(let error):
				print("Failure! Error: \(error)")
				loadFailed = true
			}
		}
	}

	var body: some View {
		List {
			if let projects = self.projects {
				if projects.isEmpty {
					Text("There are no starred projects")
				} else {
					ForEach(projects, id: \.self?.fullPath) { maybeProject in
						if let project = maybeProject {
							SmallProjectView(project)
						}
					}
				}
			} else {
				VStack {
					Image(systemName: "star")
						.resizable()
						.scaledToFit()
						.foregroundStyle(.yellow)
						.frame(width: 50, height: 50)
					if loadFailed {
						Text(failedToLoad)
					} else {
						ProgressView("Loading starred projects...")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadStarredProjects()
		}.refreshable {
			loadStarredProjects()
		}.navigationTitle("Stars of \(username)")
	}
}

#Preview {
	NavigationStack {
		UserStarredProjectsLoader(username: "felix-schindler")
	}
}
