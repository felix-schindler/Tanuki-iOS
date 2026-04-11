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
	public var filter = IssueFilter()

	@State
	private var showFilters = false

	@State
	private var project: Result<GitLabAPI.ProjectIssuesQuery.Data.Project, Error>? = nil

	init(fullPath: String) {
		self.fullPath = fullPath
	}

	private func loadIssues() {
		do {
			let responses = try Network.shared.apollo.fetch(
				query: ProjectIssuesQuery(
					fullPath: self.fullPath,
					state: GraphFilter.toFilterEnum(self.filter.state),
					search: GraphFilter.toFilter(self.filter.search),
					confidential: GraphFilter.toFilter(self.filter.confidential),
					subscribed: GraphFilter.toFilterEnum(self.filter.subscribed),
					types: self.filter.types != nil ? .some([.case(self.filter.types!)]) : .none
				),
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
				query: ProjectIssuesQuery(
					fullPath: self.fullPath,
					state: GraphFilter.toFilterEnum(self.filter.state),
					search: GraphFilter.toFilter(self.filter.search),
					confidential: GraphFilter.toFilter(self.filter.confidential),
					subscribed: GraphFilter.toFilterEnum(self.filter.subscribed),
					types: self.filter.types != nil ? .some([.case(self.filter.types!)]) : .none
				),
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
					if !(project.issuesEnabled ?? false) {
						NoContentView(
							"Issues are not enabled for this project",
							systemImage: "smallcircle.circle"
						)
					} else if let issues = project.issues?.nodes {
						if issues.isEmpty {
							NoContentView(
								"There are no issues", systemImage: "smallcircle.circle")
						} else {
							ForEach(issues, id: \.?.iid) { issue in
								if let issue {
									SmallIssueView(self.fullPath, issue)
								}
							}
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading Issues", systemImage: "smallcircle.circle", color: .green)
			}
		}.onAppear {
			loadIssues()
		}.refreshable {
			await reloadIssues()
		}.toolbar {
			HStack {
				if let project,
					case .success(let project) = project,
					let projectId = project.id.toIntId()
				{
					NavigationLink(
						destination: NewIssueView(id: projectId, fullPath: self.fullPath),
						label: {
							Label("New issue", systemImage: "plus")
						}
					).tint(.accentColor)
				}

				Button("Filter", systemImage: "line.3.horizontal.decrease") {
					showFilters = true
				}
			}
		}.sheet(isPresented: $showFilters, onDismiss: { self.showFilters = false }) {
			NavigationView {
				IssueFilterView(filter: $filter)
					.toolbar {
						AsyncButton("Apply filter", systemImage: "checkmark") {
							await reloadIssues()
							showFilters = false
						}
					}
			}
		}.navigationTitle("Issues")
	}
}

#Preview {
	NavigationView {
		ProjectIssuesLoader(fullPath: "felix-schindler/gitlab-ios")
	}
}
