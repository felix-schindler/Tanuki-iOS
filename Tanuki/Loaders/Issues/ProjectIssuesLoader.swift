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
	// MARK: - Things to load
	/// Path of project to load issues from
	private let fullPath: String

	@State
	private var project: GitLabAPI.ProjectIssuesQuery.Data.Project?

	@State
	private var loadFailed = false

	// MARK: - New issue
	@State
	private var showNewIssue = false

	init(fullPath: String) {
		self.fullPath = fullPath
		self.project = nil
	}

	private func loadIssues() {
		Network.shared.apollo.fetch(
			query: ProjectIssuesQuery(fullPath: self.fullPath)
		) { result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting issues...")
				project = graphQLResult.data?.project
			case .failure(let error):
				print("Failure! Error: \(error)")
				loadFailed = true
			}
		}
	}

	public var body: some View {
		List {
			if let project = self.project {
				if project.issuesEnabled ?? false {
					if (project.issues?.nodes?.count ?? 0) == 0 {
						VStack {
							Text("There are no issues")
						}.frame(maxWidth: .infinity, minHeight: 100)
					} else {
						ForEach(project.issues!.nodes!, id: \.self?.iid) {
							maybeIssue in
							if let issue = maybeIssue {
								SmallIssueView(self.fullPath, issue)
							}
						}
					}
				} else {
					Text("Issues are not enabled for this project")
				}
			} else {
				VStack {
					Image(systemName: "smallcircle.circle")
						.resizable()
						.scaledToFit()
						.foregroundStyle(.green)
						.frame(width: 50, height: 50)
					if loadFailed {
						Text(failedToLoad)
					} else {
						ProgressView("Loading issues")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadIssues()
		}.refreshable {
			loadIssues()
		}.toolbar {
			RoundIconButton("New issue", icon: "plus") {
				Haptics.shared.play(.light)
				showNewIssue = true
			}
		}.sheet(isPresented: $showNewIssue) {
			CreateIssueView(showNewIssue: $showNewIssue)
		}.navigationTitle("Issues")
	}
}

#Preview {
	NavigationStack {
		ProjectIssuesLoader(fullPath: "felix-schindler/gitlab-ios")
	}
}
