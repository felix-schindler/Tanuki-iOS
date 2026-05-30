//
//  UserStarredProjectsLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 30.10.21.
//  Rewritten by Felix Schindler on 03.03.24.
//

import GitLabAPI
import SwiftUI

struct UserStarredProjectsLoader: View {
	private let username: String

	@State var projects: Result<[SmallProject], Error>? = nil

	init(username: String) {
		self.username = username
	}

	private func loadProjects() {
		Task {
			do {
				let projects = try await Network.shared.service.fetchUserStarredProjects(username: self.username)
				self.projects = .success(projects)
			} catch let error {
				self.projects = .failure(error)
				Notify.status(.error)
			}
		}
	}

	private func reloadProjects() async {
		do {
			let projects = try await Network.shared.service.fetchUserStarredProjects(username: self.username)
			self.projects = .success(projects)
			Notify.status(.success)
		} catch let error {
			self.projects = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if let projects {
				switch projects {
				case .success(let projects):
					if projects.isEmpty {
						NoContentView("There are no starred projects", systemImage: "star")
					} else {
						ForEach(projects, id: \.fullPath) { project in
							SmallProjectView(project)
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading starred Projects", systemImage: "star")
			}
		}.onAppear {
			loadProjects()
		}.refreshable {
			await reloadProjects()
		}.navigationTitle("Stars of \(username)")
	}
}

#Preview {
	NavigationView {
		UserStarredProjectsLoader(username: "felix-schindler")
	}
}
