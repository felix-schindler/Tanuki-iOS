//
//  UserIssuesLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 31.10.21.
//  Rewritten by Felix Schindler on 07.03.24.
//

import GitLabAPI
import SwiftUI

struct UserIssuesLoader: View {
	private let username: String?

	init(username: String? = nil) {
		self.username = username
	}

	@State
	private var projectMemberships: Result<[IssueProjectMembership?], Error>? = nil

	@State
	private var isLoading = false

	private func loadIssues() {
		isLoading = true

		defer {
			isLoading = false
		}

		do {
			if let username {
				let responses = try Network.shared.apollo.fetch(
					query: UserIssuesQuery(username: username), cachePolicy: .cacheAndNetwork)

				Task {
					for try await response in responses {
						if let projectMemberships = response.data?.user?.projectMemberships?.nodes {
							self.projectMemberships = .success(projectMemberships)
							Notify.status(.success)
						} else if let errors = response.errors {
							for error in errors {
								Notify.status(.error, error.localizedDescription)
							}
						}
					}
				}
			} else {
				let responses = try Network.shared.apollo.fetch(
					query: CurrentUserIssuesQuery(), cachePolicy: .cacheAndNetwork)

				Task {
					for try await response in responses {
						if let projectMemberships = response.data?.currentUser?.projectMemberships?
							.nodes
						{
							self.projectMemberships = .success(projectMemberships)
							Notify.status(.success)
						} else if let errors = response.errors {
							for error in errors {
								Notify.status(.error, error.localizedDescription)
							}
						}
					}
				}
			}
		} catch let error {
			self.projectMemberships = .failure(error)
			Notify.status(.error)
		}
	}

	func reloadIssues() async {
		do {
			if let username {
				let response = try await Network.shared.apollo.fetch(
					query: UserIssuesQuery(username: username), cachePolicy: .networkOnly)

				if let projectMemberships = response.data?.user?.projectMemberships?.nodes {
					self.projectMemberships = .success(projectMemberships)
				}
			} else {
				let response = try await Network.shared.apollo.fetch(
					query: CurrentUserIssuesQuery(), cachePolicy: .networkOnly)

				if let projectMemberships = response.data?.currentUser?.projectMemberships?.nodes {
					self.projectMemberships = .success(projectMemberships)
				}
			}

			Notify.status(.success)
		} catch let error {
			self.projectMemberships = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if let projectMemberships = self.projectMemberships {
				switch projectMemberships {
				case .success(let projectMemberships):
					let validMemberships = projectMemberships.compactMap { $0 }
						.filter {
							$0.fullPath != nil && ($0._issues?.contains { $0 != nil } ?? false)
						}

					let issues: [(String, any SmallIssue)] = validMemberships.flatMap {
						membership in
						let fullPath = membership.fullPath!  // safe because we filtered nil above
						return membership._issues!.compactMap { $0 }.map { issue in
							(fullPath, issue)
						}
					}

					if issues.isEmpty {
						ContentUnavailableView(
							"All caught up!", systemImage: "smallcircle.circle")
					} else {
						ForEach(0..<issues.count, id: \.self) { index in
							let (fullPath, issue) = issues[index]
							SmallIssueView(fullPath, issue)
						}
					}
				case .failure(let error):
					FailedView(error.localizedDescription)
				}
			}
		}.onAppear {
			Task {
				loadIssues()
			}
		}.refreshable {
			await reloadIssues()
		}.navigationTitle("Issues")
	}
}

#Preview {
	NavigationStack {
		UserIssuesLoader(username: "felix-schindler")
	}
}
