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
	private var group: GroupQuery.Data.Group?

	@State
	private var loadFailed = false

	init(fullPath: String) {
		self.fullPath = fullPath
	}

	private func loadGroup() {
		Network.shared.apollo.fetch(query: GroupQuery(fullPath: self.fullPath))
		{ result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting group...")
				group = graphQLResult.data?.group
			case .failure(let error):
				print("Failure! Error: \(error)")
				loadFailed = true
			}
		}
	}

	public var body: some View {
		List {
			if let group = self.group {
				VStack(alignment: .leading) {
					HStack {
						if let avatarUrl = URL.fromAvatar(group.avatarUrl) {
							AvatarImage(avatarUrl, size: .medium)
						}
						Spacer()
						Text(group.name)
							.font(.title)
							.fontWeight(.bold)
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
											parent.name,
											icon:
												"figure.and.child.holdinghands",
											cornerRadius: 5
										)
									}
								)
							}

							PillView(group.fullName, cornerRadius: 5)
						}.font(.footnote)
					}

					if let description = group.description {
						Markdown(description)
							.markdownTheme(.gitHub)
					}
				}

				Section {
					HStack {
						Label(
							title: {
								Text("Projects")
								Spacer()
								Text(String(group.projectsCount))
							},
							icon: {
								Image(systemName: "app.gift.fill")
									.foregroundStyle(.gray)
							})
					}
					HStack {
						NavigationLink(
							destination: DescendantGroupsLoader(
								fullPath: self.fullPath),
							label: {
								Label(
									title: {
										Text("Descendant groups")
										Spacer()
										Text(
											String(group.descendantGroupsCount))
									},
									icon: {
										Image(systemName: "person.3")
											.foregroundStyle(.red)
									}
								)
							})
					}

					DisclosureGroup(
						content: {
							Text("Activity")
							Text("Members")
							Text("Labels")
							Text("Timelogs")
							Text("Custom emojis")
						},
						label: {
							Label("Manage", systemImage: "person.2")
						}
					)

					DisclosureGroup(
						content: {
							Text("Issues")
							Text("Epics")
							Text("Issue boards")
							Text("Epic boards")
							Text("Milestones")
						},
						label: {
							Label(
								"Plan", systemImage: "calendar.badge.checkmark")
						}
					)

					DisclosureGroup(
						content: {
							Text("Merge Requests")
						},
						label: {
							Label(
								"Code",
								systemImage:
									"chevron.left.forwardslash.chevron.right")
						}
					)

					DisclosureGroup(
						content: {
							Text("Releases")
							Text("Runners")
						},
						label: {
							Label("Build", systemImage: "flag")
						}
					)
				}.navigationTitle(group.path)
			} else {
				VStack(alignment: .center) {
					Image(systemName: "person.3")
						.resizable()
						.scaledToFit()
						.foregroundStyle(.red)
						.frame(width: 50, height: 50)
					if loadFailed {
						Text(LOAD_FAILED)
					} else {
						ProgressView("Loading group")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadGroup()
		}.refreshable {
			loadGroup()
		}.toolbar {
			if let group = self.group {
				ShareButton(URL(string: group.webUrl)!)

				if (group.requestAccessEnabled ?? false)
					|| group.userPermissions.createProjects
				{
					Menu(
						content: {
							if group.requestAccessEnabled ?? false {
								Button(
									"Request access",
									systemImage: "person.badge.plus"
								) {
									// TODO: Implement
								}
							}

							if group.userPermissions.createProjects {
								Button("Create project", systemImage: "plus") {
									// TODO: Implement
								}
							}
						},
						label: {
							Label("More", systemImage: "ellipsis")
								.frame(width: 16, height: 16)
						}
					)
					.menuStyle(.button)
					.buttonStyle(.bordered)
					.clipShape(Circle())
				}
			}
		}
		.navigationTitle(fullPath)
		.navigationBarTitleDisplayMode(.inline)
	}
}

#Preview {
	NavigationStack {
		GroupLoader(fullPath: "gitlab-org/production-engineering")
	}
}
