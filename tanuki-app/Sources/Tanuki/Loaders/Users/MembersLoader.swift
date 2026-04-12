//
//  ProjectMembersLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 04.03.24.
//

import GitLabAPI
import SwiftUI

enum MemberType {
	case project,
		group
}

struct MembersLoader: View {
	private let id: Int
	private let fullPath: String
	private let queryType: MemberType

	@State var memberships: Result<[Member?], Error>? = nil

	init(fullPath: String, id: Int, type: MemberType) {
		self.fullPath = fullPath
		self.id = id
		self.queryType = type
	}

	private func loadMembers() {
		do {
			switch self.queryType {
			case .project:
				let responses = try Network.shared.apollo.fetch(
					query: ProjectMembersQuery(fullPath: self.fullPath),
					cachePolicy: .cacheAndNetwork
				)

				Task {
					for try await response in responses {
						if let memberships = response.data?.project?.projectMembers?.nodes {
							self.memberships = .success(memberships)
						} else if let errors = response.errors {
							for error in errors {
								Notify
									.status(.error, error.localizedDescription)
							}
						}
					}
				}
			case .group:
				let responses = try Network.shared.apollo.fetch(
					query: GroupMembersQuery(fullPath: self.fullPath),
					cachePolicy: .cacheAndNetwork
				)

				Task {
					for try await response in responses {
						if let memberships = response.data?.group?.groupMembers?.nodes {
							self.memberships = .success(memberships)
						} else if let errors = response.errors {
							for error in errors {
								Notify
									.status(.error, error.localizedDescription)
							}
						}
					}
				}
			}
		} catch let error {
			self.memberships = .failure(error)
			Notify.status(.error)
		}
	}

	private func reloadMembers() async {
		do {
			switch self.queryType {
			case .project:
				let response = try await Network.shared.apollo.fetch(
					query: ProjectMembersQuery(fullPath: self.fullPath),
					cachePolicy: .networkOnly
				)

				if let memberships = response.data?.project?.projectMembers?.nodes {
					self.memberships = .success(memberships)
				}
			case .group:
				let response = try await Network.shared.apollo.fetch(
					query: GroupMembersQuery(fullPath: self.fullPath),
					cachePolicy: .networkOnly
				)

				if let memberships = response.data?.group?.groupMembers?.nodes {
					self.memberships = .success(memberships)
				}
			}

			Notify.status(.success)
		} catch let error {
			self.memberships = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if let memberships {
				switch memberships {
				case .success(let memberships):
					if memberships.isEmpty {
						NoContentView(
							"This project has no members",
							systemImage: "person.2"
						)
					} else {
						ForEach(memberships, id: \.?.id) { maybeMember in
							if let member = maybeMember {
								if let user = member._user {
									NavigationLink(
										destination: UserLoader(
											username: user.username
										),
										label: {
											VStack(alignment: .leading) {
												HStack {
													if let avatarUrl = URL.fromAvatar(
														user.avatarUrl
													) {
														AvatarImage(avatarUrl)
													}
													VStack(
														alignment: .leading
													) {
														Text(user.name)
														Text(
															"@\(user.username)"
														)
														.foregroundStyle(
															.secondary
														)
													}
													if let accessLevel = member
														._accessLevel?
														.lowercased()
														.capitalized
													{
														Spacer()
														PillView(accessLevel)
															.font(.footnote)
													}
												}

												ScrollView(.horizontal) {
													HStack {
														if let author = member._createdBy {
															if author.username != user.username {
																ScrollView(
																	.horizontal
																) {
																	HStack {
																		AuthorView(
																			author
																		)
																	}.font(
																		.footnote
																	)
																}
															}
														}
														if member.createdAt != nil {
															HStack(spacing: 2) {
																Image(
																	systemName: "clock"
																)
																Text(
																	Date
																		.fromToString(
																			member.createdAt!
																		)
																)
															}
														}
														if member.expiresAt != nil {
															HStack(spacing: 2) {
																Image(
																	systemName: "alarm"
																)
																Text(
																	Date
																		.fromToString(
																			member.createdAt!
																		)
																)
															}
														}
													}.font(.footnote)
												}
											}
										}
									)
								}
							}
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading Members", systemImage: "person.2")
			}
		}.toolbar {
			NavigationLink(
				destination: {
					if self.queryType == .project {
						NewMemberView(id: self.id, groupId: 0)
					} else {
						NewMemberView(id: 0, groupId: self.id)
					}
				},
				label: {
					Label("Add new Member", systemImage: "person.badge.plus")
				}
			).tint(.accentColor)
		}.onAppear {
			loadMembers()
		}.refreshable {
			await reloadMembers()
		}.navigationTitle("Members")
	}
}

#Preview {
	NavigationView {
		MembersLoader(fullPath: "gitlab-org/gitlab", id: 278_964, type: .project)
	}
}
