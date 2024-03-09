//
//  UserIssuesLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 07.03.24.
//

import GitLabAPI
import SwiftUI

struct UserIssuesLoader: View {
	private let username: String?

	init(username: String? = nil) {
		self.username = username
	}

	@State
	private var projectMemberships: [IssueProjectMembership?]? = nil

	@State
	private var loadFailed = false

	private func loadIssues() {
		if self.username != nil {
			Network.shared.apollo.fetch(
				query: UserIssuesQuery(username: self.username!)
			) { result in
				switch result {
				case .success(let graphQLResult):
					print("Success! Setting issues...")
					projectMemberships = graphQLResult.data?.user?.projectMemberships?.nodes
				case .failure(let error):
					print("Failure! Error: \(error)")
					loadFailed = true
				}
			}
		} else {
			Network.shared.apollo.fetch(query: CurrentUserIssuesQuery()) { result in
				switch result {
				case .success(let graphQLResult):
					print("Success! Setting issues...")
					projectMemberships = graphQLResult.data?.currentUser?.projectMemberships?.nodes
				case .failure(let error):
					print("Failure! Error: \(error)")
					loadFailed = true
				}
			}
		}
	}

	var body: some View {
		List {
			if let projectMemberships = self.projectMemberships {
				ForEach(projectMemberships, id: \.?.fullPath) { maybeMember in
					if let fullPath = maybeMember?.fullPath {
						if let issues = maybeMember?._issues {
							if !issues.isEmpty {
								ForEach(issues, id: \.?.reference) { maybeIssue in
									if let issue = maybeIssue {
										SmallIssueView(fullPath, issue)
									}
								}
							}
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
		UserIssuesLoader()
	}
}
