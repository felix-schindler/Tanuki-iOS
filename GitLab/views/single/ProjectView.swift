//
//  ProjectView.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//  Replaced by Felix Schindler on 14.03.23.
//

import SwiftUI
import MarkdownUI
import SwiftHttp

struct ProjectView: View {
	@State var project: Project
	
	@State var showNewIssue = false
	@State var showCommits = false
	@State var showBranches = false
	
	var body: some View {
		List {
			VStack {
				HStack {
					if let avatarUrl = URL.fromAvatar(project.avatarUrl ?? project.namespace.avatarUrl) {
						AvatarImage(url: avatarUrl)
					}
					Spacer()
					Text(project.name)
						.font(.title)
						.fontWeight(.bold)
					Spacer()
					VisibilityIcon(project.visibility)
				}
				
				if (project.description != nil && project.description != "") {
					Markdown(project.description!.emojized())
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.bottom, 0.5)
				}
				
				if (!project.tagList.isEmpty) {
					ScrollView(.horizontal) {
						HStack(spacing: 2) {
							Image(systemName: "tag")
							ForEach(project.tagList, id: \.hashValue) { tag in
								PillView(tag)
									.font(.footnote)
							}
						}
					}
				}
				
				HStack {
					if (project.owner != nil) {
						Image(systemName: "person")
						NavigationLink(project.namespace.name, destination: UserLoader(id: project.owner!.id))
					} else {
						Image(systemName: "person.3")
						NavigationLink(project.namespace.name, destination: GroupLoader(id: project.namespace.id))
					}
				}
				
				ScrollView(.horizontal) {
					HStack {
						AsyncButton(action: {
							await toggleStar()
						}, label: {
							Label("\(project.starCount) stars", systemImage: "star")
						})
						if let url = URL(string: "https://\(API.domain)/\(project.pathWithNamespace)/-/forks/new") {    // If valid link, show fork link
							if (project.forksCount != nil) {
								Link(destination: url) {
									Image(systemName: "arrow.branch")
									Text("\(project.forksCount!) forks")
								}
							}
						}
						if (project.permissions?.projectAccess?.notificationLevel != nil) {
							Menu(content: {
								Picker(selection: .constant(project.permissions!.projectAccess!.notificationLevel),
											 content: {
									Text(notificationLevel(0).firstCapitalized).tag(0)
									Text(notificationLevel(1).firstCapitalized).tag(1)
									Text(notificationLevel(2).firstCapitalized).tag(2)
									Text(notificationLevel(3).firstCapitalized).tag(3)
									Text(notificationLevel(5).firstCapitalized).tag(4)
									Text(notificationLevel(6).firstCapitalized).tag(5)
								}, label: {
									Label("Notifications", systemImage: "bell.circle")
										.labelStyle(.iconOnly)
								})
							}, label: {
								Label(notificationLevel(project.permissions!.projectAccess!.notificationLevel).firstCapitalized, systemImage: "bell.circle")
							})
							.id(UUID())
						}
					}
				}.buttonStyle(.bordered)
					.foregroundStyle(.primary)
					.controlSize(.mini)
				
				if (project.defaultBranch != nil) {
					ProjectLanguagesLoader(id: project.id)
				}
			}
			
			Section {
				if (project.issuesEnabled) {
					NavigationLink(destination: IssuesLoader(id: project.id)) {
						Label(title: {
							Text("Issues")
							Spacer()
							Text(String(project.openIssuesCount!))
						}, icon: {
							Image(systemName: "smallcircle.circle")
								.foregroundStyle(.green)
						})
					}.foregroundStyle(.primary)
				}
				
				if (project.mergeRequestsEnabled) {
					NavigationLink(destination: MergeLoader(id: project.id)) {
						Label(title: {
							Text("Merge Requests")
						}, icon: {
							Image(systemName: "arrow.triangle.pull")
								.foregroundStyle(.blue)
						})
					}.foregroundStyle(.primary)
				}
				
				DisclosureGroup(content: {
					NavigationLink("Activity", destination: EventsView(projectId: project.id))
					NavigationLink("Members", destination: MemberLoader(id: project.id))
					NavigationLink("Labels", destination: LabelsLoader(id: project.id, showEmpty: true))
					NavigationLink("Milestones", destination: MilestoneLoader(id: project.id))
				}, label: {
					Label("Manage", systemImage: "person.2")
						.foregroundStyle(.primary)
				})
				
				if (project.defaultBranch != nil) {
					DisclosureGroup(content: {
						NavigationLink("Repository", destination: TreeLoader(id: project.id, refName: project.defaultBranch!))
						NavigationLink("Branches", destination: BranchesView(id: project.id))
						NavigationLink("Commits", destination: CommitsView(id: project.id, refName: project.defaultBranch!))
						NavigationLink("Tags", destination: TagsView(id: project.id))
					}, label: {
						Label("Code", systemImage: "chevron.left.forwardslash.chevron.right")
							.foregroundStyle(.primary)
					})
				}
				
				DisclosureGroup(content: {
					NavigationLink("Pipelines", destination: PipelineLoader(id: project.id, onlyStatus: false))
					NavigationLink("Releases", destination: ReleaseView(id: project.id))
				}, label: {
					Label(title: {
						Text("Build")
						if (project.defaultBranch != nil) {
							Spacer()
							PipelineLoader(id: project.id, branch: project.defaultBranch!)
						}
					}, icon: {
						Image(systemName: "flag")
					})
					.foregroundStyle(.primary)
				})
			}
			
			if let readmePath = project.readmeUrl?.split(separator: "/").last {
				Section(readmePath) {
					FileLoader(id: project.id, filePath: String(readmePath), refName: project.defaultBranch ?? "", inline: true)
						.padding(.top, 7.5)
				}
			}
		}.toolbar {
			AsyncButton(systemImage: "square.and.arrow.up") {
				await URL(string: project.webUrl)!.share()
			}
			if (project.issuesEnabled) {
				RoundIconButton("New Issue", icon: "plus") {
					showNewIssue = true
				}
			}
		}.sheet(isPresented: $showNewIssue) {
			NewIssueView(id: project.id)
		}.navigationTitle(project.name)
			.navigationBarTitleDisplayMode(.inline)
	}
	
	private func notificationLevel(_ id: Int) -> String {
		switch (id) {
		case 0:
			return "disabled"
		case 1:
			return "participating"
		case 2:
			return "watch"
		case 3:
			return "global"
		case 4:
			return "mention"
		case 5:
			return "custom"
		default:
			return "invalid"
		}
	}
	
	private func toggleStar() async -> Void {
		let toggle = await API.req(type: ToggleStar.self, method: .post, endpoint: "\(project.pathWithNamespace)/toggle_star.json", useBase: false)
		if (toggle != nil) {
			project.starCount = toggle!.starCount
		}
	}
}

#Preview {
	NavigationStack {
		ProjectView(project: Project(id: 33025310, description: "The native SwiftUI GitLab client for iOS and iPadOS.", name: "Tanuki for GitLab", nameWithNamespace: "Felix / Tanuki for GitLab", pathWithNamespace: "felix-schindler/gitlab-ios", defaultBranch: "main", tagList: ["Tanuki", "iOS", "iPadOS", "SwiftUI", "GitLab", "App", "Client"], webUrl: "https://gitlab.com/felix-schindler/gitlab-ios", readmeUrl: "https://gitlab.com/felix-schindler/gitlab-ios/-/blob/main/README.md", avatarUrl: "https://gitlab.com/uploads/-/system/project/avatar/33025310/Tanuki-200kb.png", forksCount: 0, starCount: 1, namespace: Namespace(id: 0, name: "Felix", path: "felix-schindler", avatarUrl: ""), visibility: "public", owner: UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"), issuesEnabled: true, openIssuesCount: 12, mergeRequestsEnabled: true, permissions: Permissions(projectAccess: Access(accessLevel: 50, notificationLevel: 1))))
	}
}
