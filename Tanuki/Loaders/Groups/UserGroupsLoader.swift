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
	private var groups: [Group?]?

	@State
	private var loadFailed = false

	init(username: String? = nil) {
		self.username = username
	}

	private func loadGroups() {
		if let user = self.username {
			Network.shared.apollo.fetch(query: UserGroupsQuery(username: user)) { result in
				switch result {
				case .success(let graphQLResult):
					print("Success! Setting merge groups...")
					groups = graphQLResult.data?.user?.groups?.nodes
				case .failure(let error):
					print("Failure! Error: \(error)")
					loadFailed = true
				}
			}
		} else {
			Network.shared.apollo.fetch(query: CurrentUserGroupsQuery()) {
				result in
				switch result {
				case .success(let graphQLResult):
					print("Success! Setting merge groups...")
					groups = graphQLResult.data?.currentUser?.groups?.nodes
				case .failure(let error):
					print("Failure! Error: \(error)")
					loadFailed = true
				}
			}
		}
	}

	var body: some View {
		List {
			if let groups = self.groups {
				if groups.isEmpty {
					Text("There are no groups")
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
												if let visibility = group
													.visibility
												{
													VisibilityIcon(visibility)
												}
												Text(group.name.emojized())
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
			} else {
				VStack {
					Image(systemName: "scale.3d")
						.resizable()
						.scaledToFit()
						.foregroundStyle(.red)
						.frame(width: 50, height: 50)
					if loadFailed {
						Text(loadFailedMsg)
					} else {
						ProgressView("Loading groups")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadGroups()
		}.refreshable {
			loadGroups()
		}.navigationTitle("Groups")
	}
}

#Preview {
	NavigationStack {
		UserGroupsLoader()
	}
}
