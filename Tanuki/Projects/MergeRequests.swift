//
//  MergeRequests.swift
//  Tanuki
//
//  Created by Felix Schindler on 26.02.24.
//

import SwiftUI
import GitLabAPI

struct MergeRequests: View {
	// MARK: - Things to load
	@State
	public var fullPath: String
	
	@State
	private var project: GitLabAPI.MergeRequestsQuery.Data.Project?
	
	@State
	private var loadFailed = false
	
	init(fullPath: String) {
		self.fullPath = fullPath
		self.project = nil
	}
	
	private func loadMergeRequests() {
		Network.shared.apollo.fetch(query: MergeRequestsQuery(fullPath: self.fullPath)) { result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting merge requests...")
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
				if (!(project.mergeRequestsEnabled ?? false)) {
					VStack {
						Text("Merge requests are not enabled for this project")
					}.frame(maxWidth: .infinity, minHeight: 100)
				} else {
					if (
						project.mergeRequests == nil ||
						project.mergeRequests!.nodes == nil ||
						project.mergeRequests!.nodes!.count == 0
					) {
						VStack {
							Text("There are no merge requests")
						}.frame(maxWidth: .infinity, minHeight: 100)
					} else {
						ForEach(project.mergeRequests!.nodes!, id: \.self?.iid) { mergeRequest in
							if let mr = mergeRequest {
								VStack(alignment: .leading) {
									HStack(spacing: 5) {
										MergeStateIcon(mr.state)
										Text(mr.reference)
											.foregroundStyle(.secondary)
									}.font(.footnote)
									Text(mr.title)
									HStack(spacing: 10) {
										HStack(spacing: 2) {
											Image(systemName: "hand.thumbsup")
											Text(String(mr.upvotes))
										}
										HStack(spacing: 2) {
											Image(systemName: "hand.thumbsdown")
											Text(String(mr.downvotes))
										}
										HStack(spacing: 2) {
											Image(systemName: "note.text")
											Text(String(mr.userNotesCount ?? 0))
										}
										Spacer()
										HStack(spacing: 2) {
											Image(systemName: "clock")
											Text(Date.fromToString(mr.createdAt))
										}
										
										if let author = mr.author {
											HStack(spacing: 2) {
												Image(systemName: "person")
												Text(author.name)
											}
										}
									}.font(.footnote)
								}.swipeActions {
									Button("Close", systemImage: "minus.circle") {
										// TODO: Add action
									}.tint(.blue)
									if let webUrl = URL(string: mr.webUrl ?? "") {
										ShareLink(item: webUrl) {
											Label("Share", systemImage: "square.and.arrow.up")
										}
									}
								}
							}
						}
					}
				}
			} else if (loadFailed) {
				VStack {
					Text(LOAD_FAILED)
				}.frame(maxWidth: .infinity, minHeight: 100)
			} else {
				VStack {
					ProgressView("Loading merge requests")
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadMergeRequests()
		}.refreshable {
			loadMergeRequests()
		}.navigationTitle("Merge Requests")
	}
}

#Preview {
	NavigationStack {
		MergeRequests(fullPath: "felix-schindler/gitlab-ios")
	}
}
