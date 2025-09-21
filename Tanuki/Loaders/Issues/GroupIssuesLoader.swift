//
//  GroupIssuesLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 31.10.21.
//  Rewritten by Felix Schindler on 07.03.24.
//

import GitLabAPI
import SwiftUI

struct GroupIssuesLoader: View {
	private let fullPath: String

	init(fullPath: String) {
		self.fullPath = fullPath
	}

	@State
	private var issues: Result<[SmallIssue?], Error>? = nil

	private func loadIssues() {
		do {
			let responses = try Network.shared.apollo.fetch(
				query: GroupIssuesQuery(fullPath: self.fullPath),
				cachePolicy: .cacheAndNetwork
			)

			Task {
				for try await response in responses {
					if let issues = response.data?.group?.issues?.nodes {
						self.issues = .success(issues)
					} else if let errors = response.errors {
						for error in errors {
							Notify.status(.error, error.localizedDescription)
						}
					}
				}
			}
		} catch let error {
			self.issues = .failure(error)
			Notify.status(.error)
		}
	}

	private func reloadIssues() async {
		do {
			let response = try await Network.shared.apollo.fetch(
				query: GroupIssuesQuery(fullPath: self.fullPath),
				cachePolicy: .networkOnly
			)

			if let issues = response.data?.group?.issues?.nodes {
				self.issues = .success(issues)
			}

			Notify.status(.success)
		} catch let error {
			self.issues = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if let issues {
				switch issues {
				case .success(let issues):
					if issues.isEmpty {
						Text("There are no issues")
					} else {
						ForEach(issues, id: \.?.reference) { maybeIssue in
							if let issue = maybeIssue {
								SmallIssueView(self.fullPath, issue)
							}
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading Issues", systemImage: "smallcircle.circle", color: .green)
			}
		}.onAppear {
			loadIssues()
		}.refreshable {
			await reloadIssues()
		}.navigationTitle("Issues")
	}
}

#Preview {
	NavigationView {
		GroupIssuesLoader(fullPath: "gitlab-org")
	}
}
