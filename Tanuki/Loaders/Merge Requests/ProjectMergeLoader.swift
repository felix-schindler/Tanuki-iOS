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

	@State
	private var isLoading = false

	init(fullPath: String) {
		self.fullPath = fullPath
		self.project = nil
	}

	private func loadMergeRequests() {
		isLoading = true

		defer {
			isLoading = false
		}

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
			if isLoading {
				ProgressView("Loading merge requests")
			} else if let project {
				switch project {
				case .success(let project):
					if let mergeRequestsEnabled = project.mergeRequestsEnabled,
						!mergeRequestsEnabled
					{
						ContentUnavailableView(
							"Merge requests are not enabled for this project",
							systemImage: "arrow.triangle.pull")
					} else if let mrs = project.mergeRequests?.nodes {
						if mrs.count == 0 {
							ContentUnavailableView(
								"There are no merge requests", systemImage: "arrow.triangle.pull")
						} else {
							ForEach(project.mergeRequests!.nodes!, id: \.self?.iid) {
								mergeRequest in
								if let mr = mergeRequest {
									SmallMergeView(self.fullPath, mr)
								}
							}
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			}
		}.onAppear {
			loadMergeRequests()
		}.refreshable {
			await reloadMergeRequests()
		}.navigationTitle("Merge Requests")
	}
}

#Preview {
	NavigationStack {
		ProjectMergeLoader(fullPath: "felix-schindler/gitlab-ios")
	}
}
