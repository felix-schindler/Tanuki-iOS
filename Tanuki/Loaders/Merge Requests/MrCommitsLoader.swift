//
//  CommitsLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.03.24.
//

import GitLabAPI
import SwiftUI

struct MrCommitsLoader: View {
	private let fullPath: String
	private let iid: String

	@State
	private var project: MergeRequestCommitsQuery.Data.Project? = nil

	@State
	private var loadFailed = false

	init(fullPath: String, iid: String) {
		self.fullPath = fullPath
		self.iid = iid
	}

	private func loadCommits() {
		Network.shared.apollo.fetch(
			query: MergeRequestCommitsQuery(fullPath: self.fullPath, iid: self.iid)
		) { result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting MR commits...")
				self.project = graphQLResult.data?.project
			case .failure(let error):
				print("Failure! Error: \(error)")
				loadFailed = true
			}
		}
	}

	public var body: some View {
		List {
			if let commits = self.project?.mergeRequest?.commits?.nodes {
				if commits.isEmpty {
					Text("There are no commits in this MR")
				} else {
					let projectId = project?.id.toIntId()
					ForEach(commits, id: \.?.shortId) { maybeCommit in
						if let commit = maybeCommit {
							SmallCommitView(commit, projectId)
						}
					}
				}
			} else {
				VStack {
					if loadFailed {
						Text(failedToLoad)
					} else {
						ProgressView("Loading commits")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadCommits()
		}.refreshable {
			loadCommits()
		}.navigationTitle("Commits")
	}
}

#Preview {
	NavigationStack {
		MrCommitsLoader(fullPath: "felix-schindler/gitlab-ios", iid: "1")
	}
}
