//
//  EpicIssuesLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 31.10.21.
//  Rewritten by Felix Schindler on 07.03.24.
//

import GitLabAPI
import SwiftUI

struct EpicIssuesLoader: View {
	private let fullPath: String
	private let iid: String

	@State
	private var issues: [SmallIssue?]?

	@State
	private var loadFailed = false

	init(fullPath: String, iid: String) {
		self.fullPath = fullPath
		self.iid = iid
	}

	private func loadIssues() {
		Network.shared.apollo.fetch(
			query: EpicIssuesQuery(
				fullPath: self.fullPath,
				iid: self.iid
			)
		) { result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting issues...")
				issues = graphQLResult.data?.group?.epic?.issues?.nodes
			case .failure(let error):
				print("Failure! Error: \(error)")
				loadFailed = true
			}
		}
	}

	public var body: some View {
		List {
			if let issues = self.issues {
				if issues.isEmpty {
					Text("There are no issues")
				} else {
					ForEach(issues, id: \.?.reference) { maybeIssue in
						if let issue = maybeIssue {
							SmallIssueView(
								String(issue.reference.split(separator: "#")[0]),
								issue
							)
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
		EpicIssuesLoader(fullPath: "gitlab-org", iid: "12691")
	}
}
