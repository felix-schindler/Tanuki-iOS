//
//  GroupIssuesLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 07.03.24.
//

import GitLabAPI
import SwiftUI

struct GroupIssuesLoader: View {
	private let fullPath: String

	init(fullPath: String) {
		self.fullPath = fullPath
	}

	@State
	private var issues: [SmallIssue?]? = nil

	@State
	private var loadFailed = false

	private func loadIssues() {
		Network.shared.apollo.fetch(
			query: GroupIssuesQuery(fullPath: self.fullPath)
		) { result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting issues...")
				issues = graphQLResult.data?.group?.issues?.nodes
			case .failure(let error):
				print("Failure! Error: \(error)")
				loadFailed = true
			}
		}
	}

	var body: some View {
		List {
			if let issues = self.issues {
				if issues.isEmpty {
					Text("There are no issues")
				} else {
					ForEach(issues, id: \.?.reference) { maybeIssue in
						if let issue = maybeIssue {
							SmallIssueView(self.fullPath, issue)
						}
					}
				}
			} else {
				VStack {
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
		}.navigationTitle("Issues")
	}
}

#Preview {
	NavigationStack {
		GroupIssuesLoader(fullPath: "gitlab-org")
	}
}
