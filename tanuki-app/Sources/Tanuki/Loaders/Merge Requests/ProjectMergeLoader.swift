//
//  MergeRequests.swift
//  Tanuki
//
//  Created by Felix Schindler on 26.02.24.
//

import GitLabAPI
import SwiftUI

struct ProjectMergeLoader: View {
	private let fullPath: String

	@State
	private var project: Result<GitLabAPI.ProjectMergeRequestsQuery.Data.Project, Error>? = nil

	init(fullPath: String) {
		self.fullPath = fullPath
		self.project = nil
	}

	private func loadMergeRequests() {
		do {
			let responses = try Network.shared.apollo.fetch(
				query: ProjectMergeRequestsQuery(fullPath: self.fullPath),
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

	private func reloadMergeRequests() async {
		do {
			let response = try await Network.shared.apollo.fetch(
				query: ProjectMergeRequestsQuery(fullPath: self.fullPath),
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
			if let project {
				switch project {
				case .success(let project):
					if let mergeRequestsEnabled = project.mergeRequestsEnabled,
						!mergeRequestsEnabled
					{
						NoContentView(
							"Merge requests are not enabled for this project",
							image: "git-mr.symbols"
						)
					} else if let mrs = project.mergeRequests?.nodes {
						if mrs.count == 0 {
							NoContentView("There are no merge requests", image: "git-mr.symbols")
						} else {
							ForEach(mrs, id: \.?.iid) { mr in
								if let mr {
									SmallMergeView(self.fullPath, mr)
								}
							}
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading Merge Requests", image: "git-mr.symbols", color: .blue)
			}
		}.onAppear {
			loadMergeRequests()
		}.refreshable {
			await reloadMergeRequests()
		}.navigationTitle("Merge Requests")
	}
}

#Preview {
	NavigationView {
		ProjectMergeLoader(fullPath: "felix-schindler/gitlab-ios")
	}
}
