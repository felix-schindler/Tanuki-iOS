//
//  MergeRequests.swift
//  Tanuki
//
//  Created by Felix Schindler on 26.02.24.
//

import SwiftUI
import GitLabAPI

struct ProjectMergeLoader: View {
	private let fullPath: String
	
	@State
	private var project: GitLabAPI.ProjectMergeRequestsQuery.Data.Project?
	
	@State
	private var loadFailed = false
	
	init(fullPath: String) {
		self.fullPath = fullPath
		self.project = nil
	}
	
	private func loadMergeRequests() {
		Network.shared.apollo.fetch(query: ProjectMergeRequestsQuery(fullPath: self.fullPath)) { result in
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
								SmallMergeView(self.fullPath, mr)
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
		ProjectMergeLoader(fullPath: "felix-schindler/gitlab-ios")
	}
}
