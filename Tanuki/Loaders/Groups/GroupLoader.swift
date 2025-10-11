//
//  GroupLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.02.24.
//

import GitLabAPI
import MarkdownUI
import SwiftUI

struct GroupLoader: View {
	private let fullPath: String

	@State
	private var group: Result<GroupQuery.Data.Group, Error>? = nil

	init(fullPath: String) {
		self.fullPath = fullPath
	}

	private func loadGroup() {
		do {
			let responses = try Network.shared.apollo.fetch(
				query: GroupQuery(fullPath: self.fullPath), cachePolicy: .cacheAndNetwork)

			Task {
				for try await response in responses {
					if let group = response.data?.group {
						self.group = .success(group)
					} else if let errors = response.errors {
						for error in errors {
							Notify.status(.error, error.localizedDescription)
						}
					}
				}
			}
		} catch let error {
			self.group = .failure(error)
			Notify.status(.error)
		}
	}

	private func reloadGroup() async {
		do {
			let response = try await Network.shared.apollo.fetch(
				query: GroupQuery(fullPath: self.fullPath), cachePolicy: .networkOnly)

			if let group = response.data?.group {
				self.group = .success(group)
			}

			Notify.status(.success)
		} catch let error {
			self.group = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if let group {
				switch group {
				case .success(let group):
					VStack(alignment: .leading) {
						HStack {
							if let avatarUrl = URL.fromAvatar(group.avatarUrl) {
								AvatarImage(avatarUrl, size: .medium)
							}
							Spacer()
							if let name = group.name?.emojized() {
								Text(name)
									.font(.title)
									.fontWeight(.bold)
							}
							Spacer()
							if let visibility = group.visibility {
								VisibilityIcon(visibility)
							}
						}

						ScrollView(.horizontal) {
							HStack {
								PillView(
									String(group.groupMembersCount),
									icon: "person.2",
									cornerRadius: 5
								)

								if let parent = group.parent {
									NavigationLink(
										destination: GroupLoader(
											fullPath: parent.fullPath),
										label: {
											PillView(
												parent.name ?? parent.fullPath,
												icon:
													"figure.and.child.holdinghands",
												cornerRadius: 5
											)
										}
									)
								}

								if group.name != group.fullName {
									PillView(group.fullName ?? group.path, cornerRadius: 5)
								}
							}.font(.footnote)
						}

						if let description = group.description {
							Markdown(description)
								.markdownTheme(.gitLab)
						}
					}

					Section {
						HStack {
							NavigationLink(
								destination: ProjectsLoader(
									namespacePath: self.fullPath
								),
								label: {
									Label(
										title: {
											HStack {
												Text("Projects")
												Spacer()
												Text("\(group.projectsCount)")
											}
										},
										icon: {
											Image(systemName: "app.gift.fill")
												.foregroundStyle(.gray)
										}
									)
								}
							)
						}
						HStack {
							NavigationLink(
								destination: DescendantGroupsLoader(
									fullPath: self.fullPath),
								label: {
									Label(
										title: {
											HStack {
												Text("Descendant groups")
												Spacer()
												Text("\(group.descendantGroupsCount)")
											}
										},
										icon: {
											Image(systemName: "scale.3d")
												.foregroundStyle(.red)
										}
									)
								})
						}

						DisclosureGroup(
							content: {
								// TODO: There seems to be no way to get the activity events of a group
								// Text("Activity")
								if let groupId = group.id?.toIntId() {
									NavigationLink(
										"Members",
										destination: MembersLoader(
											fullPath: self.fullPath,
											id: groupId,
											type: .group
										)
									)
									NavigationLink(
										"Labels",
										destination: LabelsLoader(
											fullPath: self.fullPath,
											id: groupId,
											queryType: .group
										)
									)
								}
								NavigationLink(
									"Timelogs",
									destination: TimelogsLoader(
										fullPath: self.fullPath,
										queryType: .group
									)
								)
								NavigationLink(
									"Custom emojis",
									destination: CustomEmojisLoader(
										fullPath: self.fullPath
									))
							},
							label: {
								Label("Manage", systemImage: "person.2")
							}
						)

						DisclosureGroup(
							content: {
								NavigationLink(
									"Issues",
									destination: GroupIssuesLoader(fullPath: self.fullPath)
								)
								NavigationLink(
									"Epics",
									destination: GroupEpicsLoader(fullPath: self.fullPath)
								)
								if let groupId = group.id?.toIntId() {
									NavigationLink(
										"Milestones",
										destination: MilestonesLoader(
											fullPath: self.fullPath,
											id: groupId,
											queryType: .group
										)
									)
								}
							},
							label: {
								if #available(iOS 17.0, *) {
									Label("Plan", systemImage: "calendar.badge.checkmark")
								} else {
									Label("Plan", systemImage: "calendar")
								}
							}
						)

						DisclosureGroup(
							content: {
								NavigationLink(
									"Merge Requests",
									destination: GroupMergeLoader(fullPath: self.fullPath))
							},
							label: {
								Label(
									"Code",
									systemImage:
										"chevron.left.forwardslash.chevron.right")
							}
						)
					}.navigationTitle(group.path)
				case .failure(let error):
					FailedView(error.localizedDescription, icon: "scale.3d")
				}
			} else {
				LoadingView("Loading Group \(self.fullPath)", systemImage: "scale.3d")
			}
		}.onAppear {
			loadGroup()
		}.refreshable {
			await reloadGroup()
		}.toolbar {
			if let group, case .success(let group) = group {
				HStack {
					if let url = URL(string: group.webUrl) {
						ShareButton(url)
					}

					if group.userPermissions.createProjects || group.requestAccessEnabled ?? false {
						Menu("More", systemImage: "ellipsis") {
							if group.userPermissions.createProjects {
								Button("Create project", systemImage: "plus") {
									// TODO: Implement
									Notify.status(.error, "Not yet implemented")
								}
							}

							if group.requestAccessEnabled ?? false {
								Button(
									"Request access",
									systemImage: "person.badge.plus"
								) {
									// TODO: Implement
									Notify.status(.error, "Not yet implemented")
								}
							}
						}
					}
				}
			}
		}
		.navigationTitle(fullPath)
		.navigationBarTitleDisplayMode(.inline)
	}
}

#Preview {
	NavigationView {
		GroupLoader(fullPath: "gitlab-org/production-engineering")
	}
}
