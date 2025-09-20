//
//  Issues.swift
//  Tanuki
//
//  Created by Felix Schindler on 31.10.21.
//  Rewritten by Felix Schindler on 26.02.24.
//

import GitLabAPI
import SwiftUI

struct ProjectIssuesLoader: View {
	/// Path of project to load issues from
	private let fullPath: String

	@State
	private var project: Result<GitLabAPI.ProjectIssuesQuery.Data.Project, Error>? = nil

	@State
	private var isLoading = false

	init(fullPath: String) {
		self.fullPath = fullPath
		self.project = nil
	}

	private func loadIssues() {
		isLoading = true

		defer {
			isLoading = false
		}

		do {
			let responses = try Network.shared.apollo.fetch(
				query: ProjectIssuesQuery(fullPath: self.fullPath),
				cachePolicy: .cacheAndNetwork
			)

			Task {
				for try await response in responses {
					if let project = response.data?.project {
						self.project = .success(project)
					} else if let errors = response.errors {
						for error in errors {
							Notify.status(.error, error.localizedDescription)
						}
					}
				}
			}
		} catch let error {
			self.project = .failure(error)
			Notify.status(.error)
		}
	}

	private func reloadIssues() async {
		do {
			let response = try await Network.shared.apollo.fetch(
				query: ProjectIssuesQuery(fullPath: self.fullPath),
				cachePolicy: .networkOnly
			)

			if let project = response.data?.project {
				self.project = .success(project)
			}

			Notify.status(.success)
		} catch let error {
			self.project = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if isLoading {
				ProgressView("Loading issues")
			} else if let project {
				switch project {
				case .success(let project):
					if !(project.issuesEnabled ?? false) {
						ContentUnavailableView(
							"Issues are not enabled for this project",
							systemImage: "smallcircle.circle")
					} else if let issues = project.issues?.nodes {
						if issues.isEmpty {
							ContentUnavailableView(
								"There are no issues", systemImage: "smallcircle.circle")
						} else {
							ForEach(project.issues!.nodes!, id: \.self?.iid) {
								maybeIssue in
								if let issue = maybeIssue {
									SmallIssueView(self.fullPath, issue)
								}
							}
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			}
		}.onAppear {
			loadIssues()
		}.refreshable {
			loadIssues()
		}.toolbar {
			RoundIconButton("New issue", icon: "plus") {
				Haptics.shared.play(.light)
			}
		}.navigationTitle("Issues")
	}
}

#Preview {
	NavigationStack {
		ProjectIssuesLoader(fullPath: "felix-schindler/gitlab-ios")
	}
}
