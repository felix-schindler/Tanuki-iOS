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
	private let fullPath: String
	private let type: MemberType

	@State
	private var projectMembers: [Member?]? = nil

	@State
	private var loadFailed = false

	@State
	private var showNewMember = false

	@State
	private var newMemberUsername = ""

	init(fullPath: String, type: MemberType) {
		self.fullPath = fullPath
		self.type = type
	}

	private func loadMembers() {
		if self.type == .project {
			Network.shared.apollo.fetch(
				query: ProjectMembersQuery(fullPath: self.fullPath)
			) { result in
				switch result {
				case .success(let graphQLResult):
					print("Success! Setting namespace...")
					projectMembers =
						graphQLResult.data?.project?.projectMembers?.nodes
				case .failure(let error):
					print("Failure! Error: \(error)")
					loadFailed = true
				}
			}
		} else {
			Network.shared.apollo.fetch(query: GroupMembersQuery(fullPath: self.fullPath)) {
				result in
				switch result {
				case .success(let graphQLResult):
					print("Success! Setting namespace...")
					projectMembers =
						graphQLResult.data?.group?.groupMembers?.nodes
				case .failure(let error):
					print("Failure! Error: \(error)")
					loadFailed = true
				}
			}
		}
	}

	public var body: some View {
		List {
			if let memberships = self.projectMembers {
				if memberships.isEmpty {
					Text("This project has no members")
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
												if let avatarUrl = URL.fromAvatar(user.avatarUrl) {
													AvatarImage(avatarUrl)
												}
												VStack(alignment: .leading) {
													Text(user.name)
													Text("@\(user.username)")
														.foregroundStyle(.secondary)
												}
												if let accessLevel = member
													._accessLevel?.lowercased()
													.firstCapitalized
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
															ScrollView(.horizontal) {
																HStack {
																	AuthorView(author)
																}.font(.footnote)
															}
														}
													}
													if member.createdAt != nil {
														HStack(spacing: 2) {
															Image(systemName: "clock")
															Text(
																Date.fromToString(member.createdAt!)
															)
														}
													}
													if member.expiresAt != nil {
														HStack(spacing: 2) {
															Image(systemName: "alarm")
															Text(
																Date.fromToString(member.createdAt!)
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
			} else {
				VStack {
					Image(systemName: "person.2")
						.resizable()
						.scaledToFit()
						.frame(width: 50, height: 50)
					if loadFailed {
						Text(failedToLoad)
					} else {
						ProgressView("Loading project members")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.toolbar {
			RoundIconButton("Add new member", icon: "person.badge.plus") {
				showNewMember = true
				#if os(iOS)
					Haptics.shared.play(.light)
				#endif
			}
		}.sheet(isPresented: $showNewMember) {
			VStack {
				PopupHeader(
					title: "New Member",
					onClose: {
						showNewMember = false
					})
				TextField("Username", text: $newMemberUsername)
				Spacer()
				Button(
					action: {
						newMemberUsername = ""
						showNewMember = false
						Notify.status(.success)
					},
					label: {
						Text("Add member")
							.frame(maxWidth: .infinity)
					}
				)
				.tint(.green)
				.buttonStyle(.bordered)
				.controlSize(.large)
			}
			.padding()
			.presentationDetents([.large, .medium])
			.textFieldStyle(.roundedBorder)
		}.onAppear {
			loadMembers()
		}.refreshable {
			loadMembers()
		}.navigationTitle("Members")
	}
}

#Preview {
	NavigationStack {
		MembersLoader(fullPath: "gitlab-org/gitlab", type: .project)
	}
}
