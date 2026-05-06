//
//  UserIssuesLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 31.10.21.
//  Rewritten by Felix Schindler on 07.03.24.
//

import Apollo
import IOSGitLabAPI
import SwiftUI

struct UserIssuesLoader: View {
	@State
	private var projectMemberships: Result<[IssueProjectMembership?], Error>? = nil

	private func loadIssues() {
		do {
			let responses = try Network.shared.apollo.fetch(
				query: CurrentUserIssuesQuery(
					state: .some(.case(.opened)),
					search: .none,
					confidential: .none,
					subscribed: .none,
					types: .none
				),
				cachePolicy: .cacheAndNetwork
			)

			Task {
				for try await response in responses {
					if let projectMemberships = response.data?.currentUser?.projectMemberships?
						.nodes
					{
						self.projectMemberships = .success(projectMemberships)
					}
				}
			}
		} catch let error {
			self.projectMemberships = .failure(error)
		}
	}

	func reloadIssues() async {
		do {
			let response = try await Network.shared.apollo.fetch(
				query: CurrentUserIssuesQuery(
					state: .some(.case(.opened)),
					search: .none,
					confidential: .none,
					subscribed: .none,
					types: .none
				),
				cachePolicy: .networkOnly
			)

			if let projectMemberships = response.data?.currentUser?.projectMemberships?.nodes {
				self.projectMemberships = .success(projectMemberships)
			}
		} catch let error {
			self.projectMemberships = .failure(error)
		}
	}

	public var body: some View {
		List {
			if let projectMemberships {
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
						NoContentView("All caught up!", systemImage: "smallcircle.circle")
					} else {
						ForEach(0..<issues.count, id: \.self) { index in
							let (fullPath, issue) = issues[index]
							SmallIssueView(fullPath, issue)
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				ProgressView("Loading issues")
			}
		}.onAppear {
			loadIssues()
		}.refreshable {
			await reloadIssues()
		}
	}
}

#Preview {
	UserIssuesLoader()
}
