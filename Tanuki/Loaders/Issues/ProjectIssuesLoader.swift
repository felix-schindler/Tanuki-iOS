//
//  Issues.swift
//  Tanuki
//
//  Created by Felix Schindler on 26.02.24.
//

import GitLabAPI
import SwiftUI

struct ProjectIssuesLoader: View {
	// MARK: - Things to load
	/// Path of project to load issues from
	private let fullPath: String

	@State
	private var project: GitLabAPI.PorjectIssuesQuery.Data.Project?

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
			query: PorjectIssuesQuery(fullPath: self.fullPath)
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
			if let project = self.project {
				if project.issuesEnabled ?? false {
					if (project.issues?.nodes?.count ?? 0) == 0 {
						VStack {
							Text("There are no issues")
						}.frame(maxWidth: .infinity, minHeight: 100)
					} else {
						ForEach(project.issues!.nodes!, id: \.self?.iid) {
							issue in
							if issue != nil {
								NavigationLink(
									destination: IssueLoader(
										fullPath: self.fullPath, iid: issue!.iid
									),
									label: {
										VStack(alignment: .leading) {
											HStack(spacing: 5) {
												IssueStateIcon(issue!.state)
												Text(issue!.reference)
													.foregroundStyle(.secondary)
											}.font(.footnote)
											Text(issue!.title.emojized())
											HStack(spacing: 10) {
												HStack(spacing: 2) {
													Image(
														systemName:
															"hand.thumbsup")
													Text(String(issue!.upvotes))
												}
												HStack(spacing: 2) {
													Image(
														systemName:
															"hand.thumbsdown")
													Text(
														String(issue!.downvotes)
													)
												}
												HStack(spacing: 2) {
													Image(
														systemName: "note.text")
													Text(
														String(
															issue!
																.userNotesCount)
													)
												}
												Spacer()
												HStack(spacing: 2) {
													Image(systemName: "clock")
													Text(
														Date.fromToString(
															issue!.createdAt))
												}
												HStack(spacing: 2) {
													Image(systemName: "person")
													Text(issue!.author.name)
												}
											}.font(.footnote)
										}.swipeActions {
											Button(
												"Close",
												systemImage: "minus.circle"
											) {
												// TODO: Add action
											}.tint(.blue)
											ShareLink(
												item: URL(
													string: issue!.webUrl)!
											) {
												Label(
													"Share",
													systemImage:
														"square.and.arrow.up")
											}
										}
									})
							}
						}
					}
				} else {
					Text("Issues are not enabled for this project")
				}
			} else if loadFailed {
				Text(LOAD_FAILED)
			} else {
				VStack(alignment: .center) {
					ProgressView("Loading issues")
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
