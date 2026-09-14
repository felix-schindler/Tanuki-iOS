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

	@State var issues: Result<[SmallIssue?], Error>? = nil

	init(fullPath: String, iid: String) {
		self.fullPath = fullPath
		self.iid = iid
	}

	private func loadIssues() {
		do {
			let responses = try Network.shared.apollo.fetch(
				query: EpicIssuesQuery(fullPath: self.fullPath, iid: self.iid),
				cachePolicy: .cacheAndNetwork
			)

			Task {
				for try await response in responses {
					if let issues = response.data?.group?.epic?.issues?.nodes {
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
				query: EpicIssuesQuery(fullPath: self.fullPath, iid: self.iid),
				cachePolicy: .networkOnly
			)

			if let issues = response.data?.group?.epic?.issues?.nodes {
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
						NoContentView(
							"There are no issues", systemImage: "smallcircle.circle")
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
