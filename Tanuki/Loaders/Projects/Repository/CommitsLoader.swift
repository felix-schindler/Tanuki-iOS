//
//  Commits.swift
//  GitLab
//
//  Created by Felix Schindler on 02.11.21.
//

import SwiftUI

struct Commit: Codable {
	let id: String
	let shortId: String
	let title: String
	let message: String
	let authorName: String
	let authoredDate: Date
	let webUrl: String
}

struct Branch: Codable {
	let name: String
	let commit: Commit
	let merged: Bool
	let protected: Bool
	let developersCanPush: Bool
	let developersCanMerge: Bool
	let canPush: Bool
}

struct CommitsLoader: View {
	@Environment(\.presentationMode)
	private var presentationMode: Binding<PresentationMode>

	// MARK: - Load config
	/// Project ID
	private var projectId: Int
	/// Branch name
	@State
	private var refName: String

	init(_ projectId: Int, refName: String) {
		self.projectId = projectId
		self.refName = refName
	}

	// MARK: - Load data
	@State
	private var branches: [Branch]? = nil

	@State
	private var commits: [Commit]? = nil

	@State
	private var loadFailed: Bool = false

	var body: some View {
		List {
			if commits != nil {
				if commits!.isEmpty {
					Text("You'll see your commits after you pushed something to branch \(refName)")
				} else {
					HStack {
						Text("On branch")
						if branches != nil {
							Picker("", selection: $refName) {
								ForEach(branches!, id: \.name) { branch in
									Text(branch.name).tag(branch.name)
								}
							}.pickerStyle(.menu)
								.onChange(of: refName) { _ in
									Task { await getCommits() }
								}
						} else {
							Picker("", selection: $refName) {
								Text(refName).tag(refName)
							}.pickerStyle(.menu)
						}
					}
					Section("Commits") {
						ForEach(commits!, id: \.id) { commit in
							NavigationLink(
								destination: DiffLoader(projectId: self.projectId, commitSha: commit.id),
								label: {
									HStack {
										VStack(alignment: .leading) {
											Text(commit.title.emojized())
												.fontWeight(.medium)

											VStack(alignment: .leading) {
												HStack {
													Text(
														"Authored by \(commit.authorName) at \(commit.authoredDate.toString(.short))"
													)
												}.font(.footnote)
											}
										}
										Spacer()
										VStack {
											SignatureLoader(projectId: self.projectId, commitId: commit.id)
											Text(commit.shortId)
												.textSelection(.enabled)
												.font(.system(.caption, design: .monospaced))
										}
									}.swipeActions {
										ShareButton(URL(string: commit.webUrl)!)
									}
								}
							)
						}
					}
				}
			} else {
				if loadFailed {
					Text(failedToLoad)
						.foregroundStyle(.red)
				} else {
					ProgressView()
				}
			}
		}.onAppear {
			Task {
				await getCommits()
				await getBranches()
				loadFailed = (commits == nil) || (branches == nil)
			}
		}.refreshable {
			await getCommits()
			await getBranches()
			loadFailed = (commits == nil) || (branches == nil)
		}.navigationBarTitle("Commits")
			.headerProminence(.increased)
	}

	private func getCommits() async {
		commits = await API.get(
			type: [Commit].self,
			endpoint: "projects/\(projectId)/repository/commits",
			query: ["ref_name": refName]
		)
	}

	private func getBranches() async {
		branches = await API.get(
			type: [Branch].self,
			endpoint: "projects/\(projectId)/repository/branches"
		)
	}
}

#Preview {
	NavigationStack {
		CommitsLoader(33_025_310, refName: "main")
	}
}
