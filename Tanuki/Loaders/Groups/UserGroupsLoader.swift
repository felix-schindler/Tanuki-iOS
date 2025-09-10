//
//  UserGroupsLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.02.24.
//

import GitLabAPI
import SwiftUI

struct UserGroupsLoader: View {
	private let username: String?

	@State
	private var groups: Result<[Group?], Error>? = nil

	@State
	private var isLoading = false

	init(username: String? = nil) {
		self.username = username
	}

	private func loadGroups() {
		isLoading = true

		defer {
			isLoading = false
		}

		do {
			if let username {
				let responses = try Network.shared.apollo.fetch(
					query: UserGroupsQuery(username: username), cachePolicy: .cacheAndNetwork)

				Task {
					for try await response in responses {
						if let groups = response.data?.user?.groups?.nodes {
							self.groups = .success(groups)
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
					query: CurrentUserGroupsQuery(), cachePolicy: .cacheAndNetwork)

				Task {
					for try await response in responses {
						if let groups = response.data?.currentUser?.groups?.nodes {
							self.groups = .success(groups)
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
			self.groups = .failure(error)
			Notify.status(.error)
		}
	}

	private func reloadGroups() async {
		do {
			if let username {
				let response = try await Network.shared.apollo.fetch(
					query: UserGroupsQuery(username: username), cachePolicy: .networkOnly)

				if let groups = response.data?.user?.groups?.nodes {
					self.groups = .success(groups)
				}
			} else {
				let response = try await Network.shared.apollo.fetch(
					query: CurrentUserGroupsQuery(), cachePolicy: .networkOnly)

				if let groups = response.data?.currentUser?.groups?.nodes {
					self.groups = .success(groups)
				}
			}

			Notify.status(.success)
		} catch let error {
			self.groups = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if isLoading {
				ProgressView("Loading groups")
			} else if let groups {
				switch groups {
				case .success(let groups):
					if groups.isEmpty {
						ContentUnavailableView("There are no groups", systemImage: "scale.3d")
					} else {
						ForEach(groups, id: \.self?.fullPath) { maybeGroup in
							if let group = maybeGroup {
								NavigationLink(
									destination: GroupLoader(
										fullPath: group.fullPath),
									label: {
										HStack {
											if let url = URL.fromAvatar(
												group.avatarUrl ?? "")
											{
												AvatarImage(url, size: .medium)
											}

											VStack(alignment: .leading) {
												HStack {
													if let visibility = group.visibility {
														VisibilityIcon(visibility)
													}
													if let groupName = group._name?.emojized() {
														Text(groupName)
													}
												}

												HStack(spacing: 10) {
													HStack(spacing: 2) {
														Image(
															systemName: "person.2")
														Text(
															String(
																group
																	.groupMembersCount
															))
													}

													HStack(spacing: 2) {
														Image(
															systemName:
																"app.gift.fill")
														Text(
															String(
																group.projectsCount)
														)
													}
												}.font(.footnote)
											}

											if let accessLevel = group._accessLevel {
												Spacer()
												PillView(
													accessLevel.lowercased()
														.firstCapitalized
												)
												.font(.footnote)
											}
										}
									})
							}
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			}
		}.onAppear {
			loadGroups()
		}.refreshable {
			await reloadGroups()
		}.navigationTitle("Groups")
	}
}

#Preview {
	NavigationStack {
		UserGroupsLoader()
	}
}
