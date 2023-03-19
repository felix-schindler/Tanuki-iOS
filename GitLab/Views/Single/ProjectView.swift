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
	
	@State var showNewIssue: Bool = false
	@State var showCommits: Bool = false
	@State var showBranches: Bool = false
	
	var body: some View {
		List {
			Section("Info") {
				HStack {
					if (project.avatarUrl != nil) {
						AsyncImage(url: URL(string: project.avatarUrl!)) { phase in
							switch phase {
							case .empty:
								ProgressView()
							case .success(let image):
								image
									.resizable()
									.scaledToFit()
									.frame(width: 50, height: 50)
									.cornerRadius(10)
							default:
								EmptyView()
							}
						}
					}
					
					if (project.description != nil && project.description != "") {
						Markdown(project.description!.emojized())
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(.bottom, 0.5)
					}
				}
				
				if (!project.tagList.isEmpty) {
					ScrollView(.horizontal) {
						HStack {
							ForEach(project.tagList, id: \.hashValue) { tag in
								Text(tag)
									.font(.caption)
									.padding(.horizontal, 6)
									.padding(.vertical, 4)
									.background(Color(.systemGray3))
									.cornerRadius(10)
							}
						}
					}
				}
				
				HStack {
					Image(systemName: "number.circle")
					Text(String(project.id))
					Spacer()
					if (project.owner != nil) {
						Image(systemName: "person")
					} else {
						Image(systemName: "person.3")
					}
					Text(project.namespace.name)
					Spacer()
					if (project.visibility == "private") {
						Image(systemName: "lock")
					} else if (project.visibility == "internal") {
						Image(systemName: "shield.lefthalf.filled")
					} else if (project.visibility == "public") {
						Image(systemName: "globe")
					}
					Text(project.visibility.firstCapitalized)
				}
				
				ScrollView(.horizontal) {
					HStack {
						Button(action: {
							Task.init { await toggleStar() }
						}) {
							Image(systemName: "star")
							Text("\(project.starCount) stars")
						}.buttonStyle(.bordered)
							.foregroundColor(.primary)
						if let url = URL(string: "https://\(API.domain)/\(project.pathWithNamespace)/-/forks/new") {    // If valid link, show fork link
							if (project.forksCount != nil) {
								Link(destination: url) {
									Image(systemName: "arrow.branch")
									Text("\(project.forksCount!) forks")
								}
								.buttonStyle(.bordered)
								.foregroundColor(.primary)
							}
						}
						if (project.permissions?.projectAccess?.notificationLevel != nil) {
							/* There's a bug (explained here: https://gist.github.com/atrinh0/3df23140ba39df05692befb7153c8285)
							 * where the icon of a label in a Picker is not displayed. You still have to give the Picker a Label.
							 * Therefore we have to use a Picker inside a Menu. The menu label is displayed correctly.
							 * When this is fixed (which I don't think will happen) we can delete the Menu alltogether.
							 */
							Menu {
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
							} label: {
								Label(notificationLevel(project.permissions!.projectAccess!.notificationLevel).firstCapitalized, systemImage: "bell.circle")
							}.buttonStyle(.bordered)
								.foregroundColor(.primary)
						}
					}
				}
				
				ProjectLanguagesLoader(id: project.id)
			}
			
			Section("Project") {
				HStack {
					Image(systemName: "text.line.first.and.arrowtriangle.forward")
						.foregroundColor(.purple)
					Button(action: {showCommits = true}) {
						Text("Commits")
					}.foregroundColor(.primary)
				}
				
				HStack {
					Image(systemName: "square.on.square.intersection.dashed")
						.foregroundColor(.orange)
					Button(action: {showBranches = true}) {
						Text("Branches")
					}.foregroundColor(.primary)
				}
				
				if (project.issuesEnabled) {
					NavigationLink(destination: ProjectIssuesLoader(id: project.id)) {
						HStack {
							Image(systemName: "smallcircle.circle")
								.foregroundColor(.green)
							Text("Issues")
							Spacer()
							Text(String(project.openIssuesCount!))
						}
					}.foregroundColor(.primary)
				}
				
				if (project.mergeRequestsEnabled) {
					NavigationLink(destination: ProjectMergeLoader(id: project.id)) {
						HStack {
							Image(systemName: "arrow.triangle.pull")
								.foregroundColor(.blue)
							Text("Merge Requests")
								.frame(maxWidth: .infinity, alignment: .leading)
						}
					}.foregroundColor(.primary)
				}
				
				NavigationLink(destination: TreeLoader(id: project.id, refName: project.defaultBranch ?? "")) {
					HStack {
						Image(systemName: "chevron.left.forwardslash.chevron.right")
							.foregroundColor(.pink)
						Text("Files")
							.frame(maxWidth: .infinity, alignment: .leading)
					}
				}.foregroundColor(.primary)
				
				NavigationLink(destination: PipelineLoader(id: project.id, branch: "", onlyStatus: false)) {
					HStack {
						Text("🚀")
						Text("Pipelines")
						Spacer()
						if (project.defaultBranch != nil) {
							PipelineLoader(id: project.id, branch: project.defaultBranch!)
						}
					}
				}.foregroundColor(.primary)
				
				DisclosureGroup(content: {
					NavigationLink(destination: ProjectMemberLoader(id: project.id)) {
						HStack {
							Image(systemName: "person.2")
							Text("Members")
						}
					}.foregroundColor(.primary)

					NavigationLink(destination: ProjectLabelsLoader(id: project.id)) {
						HStack {
							Image(systemName: "tag.circle")
							Text("Labels")
						}
					}.foregroundColor(.primary)
				}, label: {
					HStack {
						Image(systemName: "ellipsis.circle")
						Text("More")
					}
				})
			}
			
			if (project.readmeUrl != nil) {
				let readmePath = project.readmeUrl!.split(separator: "/").last
				if (readmePath != nil) {
					Section("README") {
						FileLoader(id: project.id, filePath: String(readmePath!), refName: project.defaultBranch ?? "", inline: true)
							.padding(.top, 7.5)
					}
				}
			}
		}.navigationTitle(project.name)
			.toolbar {
				ToolbarItemGroup(placement: .navigationBarTrailing) {
					Button(action: { share() }) {
						Image(systemName: "square.and.arrow.up")
					}
					if (project.issuesEnabled) {
						Button(action: {showNewIssue = true}) {
							Image(systemName: "plus.circle")
						}
					}
				}
			}.sheet(isPresented: $showNewIssue) {
				NewIssueView(id: project.id)
			}.sheet(isPresented: $showCommits) {
				CommitsView(id: project.id, refName: project.defaultBranch ?? "")
			}.sheet(isPresented: $showBranches) {
				BranchesView(id: project.id)
			}
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
	
	private func share() {
		guard let urlShare = URL(string: project.webUrl) else { return }
		let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
		
		let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
		windowScene?.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
	}
}

struct ProjectView_Previews_Previews: PreviewProvider {
	static var previews: some View {
		ProjectView(project: Project(id: 33025310, description: "The native SwiftUI GitLab client for iOS and iPadOS.", name: "Tanuki for GitLab", nameWithNamespace: "Felix / Tanuki for GitLab", pathWithNamespace: "felix-schindler/gitlab-ios", defaultBranch: "main", tagList: ["Tanuki", "iOS", "iPadOS", "SwiftUI", "GitLab", "App", "Client"], webUrl: "https://gitlab.com/felix-schindler/gitlab-ios", readmeUrl: "https://gitlab.com/felix-schindler/gitlab-ios/-/blob/main/README.md", avatarUrl: "https://gitlab.com/uploads/-/system/project/avatar/33025310/Tanuki-200kb.png", forksCount: 0, starCount: 1, namespace: Namespace(name: "Felix", path: "felix-schindler"), visibility: "public", owner: UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"), issuesEnabled: true, mergeRequestsEnabled: true, permissions: Permissions(projectAccess: Access(accessLevel: 50, notificationLevel: 3))))
	}
}
