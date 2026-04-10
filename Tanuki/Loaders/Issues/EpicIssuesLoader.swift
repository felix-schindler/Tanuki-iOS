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
	private var issues: Result<[SmallIssue?], Error>? = nil

	@State
	private var loadTask: Task<Void, Never>?

	init(fullPath: String, iid: String) {
		self.fullPath = fullPath
		self.iid = iid
	}

	private func loadIssues() {
		self.loadTask?.cancel()
		self.loadTask = Task {
			do {
				let responses = try await Network.shared.apollo.fetch(
					query: EpicIssuesQuery(fullPath: self.fullPath, iid: self.iid),
					cachePolicy: .cacheAndNetwork
				)

				for try await response in responses {
					if Task.isCancelled { return }
					if let issues = response.data?.group?.epic?.issues?.nodes {
						self.issues = .success(issues)
					} else if let errors = response.errors {
						for error in errors {
							Notify.status(.error, error.localizedDescription)
						}
					}
				}
			} catch {
				if !Task.isCancelled {
					self.issues = .failure(error)
					Notify.status(.error)
				}
			}
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

#Preview {
	NavigationView {
		EpicIssuesLoader(fullPath: "gitlab-org", iid: "12691")
	}
}
