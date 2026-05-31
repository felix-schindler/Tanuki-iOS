//
//  GroupLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.02.24.
//

import GitLabAPI
//import MarkdownUI
import SwiftUI

struct GroupLoader: View {
	private let fullPath: String

	@State var group: Result<Group_Group, Error>? = nil

	@State var navigationActive = false

	init(fullPath: String) {
		self.fullPath = fullPath
	}

	private func loadGroup() {
		Task {
			do {
				let payload = try await Network.shared.service.fetchGroup(fullPath: self.fullPath)
				self.group = .success(payload)
			} catch let error {
				self.group = .failure(error)
				Notify.status(.error)
			}
		}
	}

	private func reloadGroup() async {
		do {
			let payload = try await Network.shared.service.fetchGroup(fullPath: self.fullPath, strategy: .networkOnly)
			self.group = .success(payload)
			Notify.status(.success)
		} catch let error {
			self.group = .failure(error)
			Notify.status(.error)
		}
	}

	private func requestAccess(_ groupId: Int) async {
		do {
			_ = try await API.req(type: UserSmall.self, method: .post, endpoint: "groups/\(groupId)/access_requests")
			Notify.status(.success, "Access request sent", systemImage: "checkmark")
		} catch let error {
			Notify.status(.error, "Access request failed", error.localizedDescription, systemImage: "xmark")
		}
	}

	public var body: some View {
		List {
			if let group {
				switch group {
				case .success(let group):
					GroupInfoHeader(group: group)
					GroupSections(group: group, fullPath: fullPath)
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
					if let url = URL(string: group.webUrl ?? "") {
						ShareButton(url)
					}

					if group.userPermissions?.createProjects == "true" || group.requestAccessEnabled == "true" {
						Menu("More", systemImage: "ellipsis") {
							if group.userPermissions?.createProjects == "true" {
								Button("Create project", systemImage: "plus") {
									navigationActive = true
								}
							}

							if group.requestAccessEnabled == "true",
								let groupId = group.id?.toIntId()
							{
								AsyncButton(
									"Request access",
									systemImage: "person.badge.plus"
								) {
									await requestAccess(groupId)
								}
							}
						}
					}
				}
			}
		}.background {
			NavigationLink(
				isActive: $navigationActive,
				destination: {
					if let group, case .success(let group) = group,
						let groupId = group.id?.toIntId()
					{
						NewProjectView(groupId)
					} else {
						FailedView("Form couldn't be opened because the namespace ID is not defined")
					}
				},
				label: {
					EmptyView()
				}
			)
		}
		.navigationTitle(fullPath)
		.navigationBarTitleDisplayMode(.inline)
	}
}

struct GroupInfoHeader: View {
	let group: Group_Group

	var body: some View {
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
					if let groupMembersCount = group.groupMembersCount {
						PillView(groupMembersCount, icon: "person.2", cornerRadius: 5)
					}

					if let parent = group.parent {
						NavigationLink(destination: GroupLoader(fullPath: parent.fullPath ?? "")) {
							PillView(parent.name ?? parent.fullPath ?? "", icon: "figure.and.child.holdinghands", cornerRadius: 5)
						}
					}

					if let fullName = group.fullName, group.name != fullName {
						PillView(fullName, cornerRadius: 5)
					} else if let path = group.path, group.name != path {
						PillView(path, cornerRadius: 5)
					}
				}.font(.footnote)
			}

			if let description = group.description {
				Markdown(description)
					.markdownTheme(.gitLab)
			}
		}
	}
}

struct GroupSections: View {
	let group: Group_Group
	let fullPath: String

	var body: some View {
		Section {
			HStack {
				NavigationLink(destination: ProjectsLoader(namespacePath: fullPath)) {
					Label(title: {
						HStack {
							Text("Projects")
							Spacer()
							if let projectsCount = group.projectsCount {
								Text(projectsCount)
							}
						}
					}, icon: {
						Image(systemName: "app.gift.fill").foregroundStyle(.gray)
					})
				}
			}
			HStack {
				NavigationLink(destination: GroupsLoader(parentPath: fullPath)) {
					Label(title: {
						HStack {
							Text("Descendant groups")
							Spacer()
							if let descendantGroupsCount = group.descendantGroupsCount {
								Text(descendantGroupsCount)
							}
						}
					}, icon: {
						Image(systemName: "scale.3d").foregroundStyle(.red)
					})
				}
			}

			DisclosureGroup(content: {
				if let groupId = group.id?.toIntId() {
					NavigationLink("Members", destination: MembersLoader(fullPath: fullPath, id: groupId, type: .group))
					NavigationLink("Labels", destination: LabelsLoader(fullPath: fullPath, id: groupId, queryType: .group))
				}
				NavigationLink("Timelogs", destination: TimelogsLoader(fullPath: fullPath, queryType: .group))
				NavigationLink("Custom emojis", destination: CustomEmojisLoader(fullPath: fullPath))
			}, label: {
				Label("Manage", systemImage: "person.2")
			})

			DisclosureGroup(content: {
				NavigationLink("Issues", destination: GroupIssuesLoader(fullPath: fullPath))
				NavigationLink("Epics", destination: GroupEpicsLoader(fullPath: fullPath))
				if let groupId = group.id?.toIntId() {
					NavigationLink("Milestones", destination: MilestonesLoader(fullPath: fullPath, id: groupId, queryType: .group))
				}
			}, label: {
				if #available(iOS 17.0, *) {
					Label("Plan", systemImage: "calendar.badge.checkmark")
				} else {
					Label("Plan", systemImage: "calendar")
				}
			})

			DisclosureGroup(content: {
				NavigationLink("Merge Requests", destination: GroupMergeLoader(fullPath: fullPath))
			}, label: {
				Label("Code", systemImage: "chevron.left.forwardslash.chevron.right")
			})
		}
	}
}

#Preview {
	NavigationView {
		GroupLoader(fullPath: "gitlab-org/production-engineering")
	}
}
