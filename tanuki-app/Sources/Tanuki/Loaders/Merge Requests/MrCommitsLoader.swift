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

	@State var commits: Result<[NewCommit], Error>? = nil

	init(fullPath: String, iid: String) {
		self.fullPath = fullPath
		self.iid = iid
	}

	private func loadCommits() {
		Task {
			do {
				let response = try await Network.shared.service.fetchMergeRequestCommits(fullPath: self.fullPath, iid: self.iid)
				let commits = response.mergeRequest?.commits?.nodes?.map { node in
					NewCommitStruct(
						id: node.id ?? "",
						title: node.title,
						shortId: node.shortId ?? "",
						authorName: node.authorName,
						authoredDate: node.authoredDate,
						webUrl: node.webUrl ?? "",
						_signatureVerificationStatus: node.signature?.verificationStatus,
						_lastPipelineStatus: node.pipelines?.nodes?.status.flatMap(PipelineStatusEnum.init)
					)
				} ?? []
				self.commits = .success(commits)
			} catch let error {
				self.commits = .failure(error)
				Notify.status(.error)
			}
		}
	}

	private func reloadCommits() async {
		do {
			let response = try await Network.shared.service.fetchMergeRequestCommits(fullPath: self.fullPath, iid: self.iid)
			let commits = response.mergeRequest?.commits?.nodes?.map { node in
				NewCommitStruct(
					id: node.id ?? "",
					title: node.title,
					shortId: node.shortId ?? "",
					authorName: node.authorName,
					authoredDate: node.authoredDate,
					webUrl: node.webUrl ?? "",
					_signatureVerificationStatus: node.signature?.verificationStatus,
					_lastPipelineStatus: node.pipelines?.nodes?.status.flatMap(PipelineStatusEnum.init)
				)
			} ?? []
			self.commits = .success(commits)
			Notify.status(.success)
		} catch let error {
			self.commits = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if let commits {
				switch commits {
				case .success(let commits):
					if commits.isEmpty {
						NoContentView(
							"There are no commits in this MR",
							systemImage: "circle.and.line.horizontal")
					} else {
						ForEach(commits, id: \.shortId) { commit in
							SmallCommitView(commit)
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading Commits", systemImage: "circle.and.line.horizontal")
			}
		}.onAppear {
			loadCommits()
		}.refreshable {
			await reloadCommits()
		}.navigationTitle("Commits")
	}
}

#Preview {
	NavigationView {
		MrCommitsLoader(fullPath: "felix-schindler/gitlab-ios", iid: "1")
	}
}
