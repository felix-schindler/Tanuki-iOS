//
//  GroupProjectsLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.02.24.
//

import GitLabAPI
import SwiftUI

struct GroupProjectsLoader: View {
	private let fullPath: String

	@State
	private var projects: [GroupProjectsQuery.Data.Group.Projects.Node?]? = nil

	@State
	private var loadFailed = false

	init(fullPath: String) {
		self.fullPath = fullPath
	}

	private func loadGroupProjects() {
		Network.shared.apollo.fetch(
			query: GroupProjectsQuery(fullPath: self.fullPath)
		) {
			result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting projects...")
				projects = graphQLResult.data?.group?.projects.nodes
			case .failure(let error):
				print("Failure! Error: \(error)")
				loadFailed = true
			}
		}
	}

	#if !os(macOS)
		public var body: some View {
			main.navigationBarTitleDisplayMode(.large)
		}
	#else
		public var body: some View {
			main
		}
	#endif

	var main: some View {
		List {
			if let projects = self.projects {
				if projects.isEmpty {
					Text("The group \(self.fullPath) doesn't have any projects")
				} else {
					ForEach(projects, id: \.self?.fullPath) { maybeProject in
						if let project = maybeProject {
							SmallProjectView(project)
						}
					}
				}
			} else {
				VStack {
					Image(systemName: "app.gift.fill")
						.resizable()
						.scaledToFit()
						.foregroundStyle(.gray)
						.frame(width: 50, height: 50)
					if loadFailed {
						Text(loadFailedMsg)
					} else {
						ProgressView("Loading projects")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadGroupProjects()
		}.refreshable {
			loadGroupProjects()
		}.navigationTitle("Projects")
	}
}

#Preview {
	NavigationStack {
		GroupProjectsLoader(fullPath: "gitlab-org")
	}
}
