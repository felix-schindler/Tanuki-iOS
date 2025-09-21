//
//  UserProjectsLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 30.10.21.
//  Rewritten by Felix Schindler on 29.02.24.
//

import GitLabAPI
import SwiftUI

struct UserProjectsLoader: View {
	private let username: String?

	@State
	private var projectMemberships: Result<[ProjectMembership?], Error>? = nil

	init(username: String? = nil) {
		self.username = username
	}

	private func loadProjects() {
		do {
			if let username {
				let responses = try Network.shared.apollo.fetch(
					query: UserMembershipProjectsQuery(username: username),
					cachePolicy: .cacheAndNetwork
				)

				Task {
					for try await response in responses {
						if let projectMemberships = response.data?.user?.projectMemberships?.nodes {
							self.projectMemberships = .success(projectMemberships)
						} else if let errors = response.errors {
							for error in errors {
								Notify.status(.error, error.localizedDescription)
							}
						}
					}
				}
			} else {
				let responses = try Network.shared.apollo.fetch(
					query: CurrentUserMembershipProjectsQuery(),
					cachePolicy: .cacheAndNetwork
				)

				Task {
					for try await response in responses {
						if let projectMemberships = response.data?.currentUser?.projectMemberships?
							.nodes
						{
							self.projectMemberships = .success(projectMemberships)
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

	private func reloadProjects() async {
		do {
			if let username {
				let response = try await Network.shared.apollo.fetch(
					query: UserMembershipProjectsQuery(username: username),
					cachePolicy: .networkOnly
				)

				if let projectMemberships = response.data?.user?.projectMemberships?.nodes {
					self.projectMemberships = .success(projectMemberships)
				}
			} else {
				let response = try await Network.shared.apollo.fetch(
					query: CurrentUserMembershipProjectsQuery(),
					cachePolicy: .networkOnly
				)

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
			if let projectMemberships {
				switch projectMemberships {
				case .success(let projectMemberships):
					if projectMemberships.isEmpty {
						NoContentView(
							"There are no projects", systemImage: "app.gift.fill")
					} else {
						ForEach(projectMemberships, id: \.?._project?.fullPath) { memberShip in
							if let project = memberShip?._project {
								SmallProjectView(project)
							}
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading Projects", systemImage: "app.gift.fill")
			}
		}.onAppear {
			loadProjects()
		}.refreshable {
			await reloadProjects()
		}.navigationTitle("Projects")
	}
}

#Preview {
	NavigationView {
		UserProjectsLoader(username: "felix-schindler")
	}
}
