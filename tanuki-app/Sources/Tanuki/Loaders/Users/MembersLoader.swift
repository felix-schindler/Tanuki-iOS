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

	@State var memberships: Result<[Member], Error>? = nil

	init(fullPath: String, id: Int, type: MemberType) {
		self.fullPath = fullPath
		self.id = id
		self.queryType = type
	}

	private func loadMembers() {
		Task {
			do {
				switch self.queryType {
				case .project:
					let response = try await Network.shared.service.fetchProjectMembers(fullPath: self.fullPath)
					let members =
						response.projectMembers?.nodes?.map { node -> MemberStruct in
							MemberStruct(
								id: node.id ?? "",
								createdAt: node.createdAt,
								expiresAt: node.expiresAt,
								_accessLevel: node.accessLevel?.stringValue,
								_user: node.user.map { MyAuthor(avatarUrl: $0.avatarUrl, name: $0.name ?? $0.username ?? "", username: $0.username ?? "") },
								_createdBy: node.createdBy.map { MyAuthor(avatarUrl: $0.avatarUrl, name: $0.name ?? $0.username ?? "", username: $0.username ?? "") }
							)
						} ?? []
					self.memberships = .success(members)
				case .group:
					let response = try await Network.shared.service.fetchGroupMembers(fullPath: self.fullPath)
					let members =
						response.groupMembers?.nodes?.map { node -> MemberStruct in
							MemberStruct(
								id: node.id ?? "",
								createdAt: node.createdAt,
								expiresAt: node.expiresAt,
								_accessLevel: node.accessLevel?.stringValue,
								_user: node.user.map { MyAuthor(avatarUrl: $0.avatarUrl, name: $0.name ?? $0.username ?? "", username: $0.username ?? "") },
								_createdBy: node.createdBy.map { MyAuthor(avatarUrl: $0.avatarUrl, name: $0.name ?? $0.username ?? "", username: $0.username ?? "") }
							)
						} ?? []
					self.memberships = .success(members)
				}
			} catch let error {
				self.memberships = .failure(error)
				Notify.status(.error)
			}
		}
	}

	private func reloadMembers() async {
		do {
			switch self.queryType {
			case .project:
				let response = try await Network.shared.service.fetchProjectMembers(fullPath: self.fullPath)
				let members =
					response.projectMembers?.nodes?.map { node -> MemberStruct in
						MemberStruct(
							id: node.id ?? "",
							createdAt: node.createdAt,
							expiresAt: node.expiresAt,
							_accessLevel: node.accessLevel?.stringValue,
							_user: node.user.map { MyAuthor(avatarUrl: $0.avatarUrl, name: $0.name ?? $0.username ?? "", username: $0.username ?? "") },
							_createdBy: node.createdBy.map { MyAuthor(avatarUrl: $0.avatarUrl, name: $0.name ?? $0.username ?? "", username: $0.username ?? "") }
						)
					} ?? []
				self.memberships = .success(members)
			case .group:
				let response = try await Network.shared.service.fetchGroupMembers(fullPath: self.fullPath)
				let members =
					response.groupMembers?.nodes?.map { node -> MemberStruct in
						MemberStruct(
							id: node.id ?? "",
							createdAt: node.createdAt,
							expiresAt: node.expiresAt,
							_accessLevel: node.accessLevel?.stringValue,
							_user: node.user.map { MyAuthor(avatarUrl: $0.avatarUrl, name: $0.name ?? $0.username ?? "", username: $0.username ?? "") },
							_createdBy: node.createdBy.map { MyAuthor(avatarUrl: $0.avatarUrl, name: $0.name ?? $0.username ?? "", username: $0.username ?? "") }
						)
					} ?? []
				self.memberships = .success(members)
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
						ForEach(memberships, id: \.id) { member in
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
