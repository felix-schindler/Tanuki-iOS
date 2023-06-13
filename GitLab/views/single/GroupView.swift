//
//  GroupView.swift
//  GitLab
//
//  Created by Felix Schindler on 08.03.23.
//

import SwiftUI
import MarkdownUI

struct GroupView: View {
	@State var group: Group
	@State var updateFunction: () async -> Group?
	
	var body: some View {
		List {
			VStack {
				HStack {
					if let avatarUrl = URL.fromAvatar(group.avatarUrl) {
						AvatarImage(url: avatarUrl)
					}
					HStack(spacing: 2) {
						VisibilityIcon(group.visibility)
						Text(group.name)
					}
					Spacer()
					VStack(alignment: .trailing) {
						Text("ID: \(String(group.id))")
							.textSelection(.enabled)
						Text(group.createdAt.toDateString())
					}.font(.footnote)
						.foregroundStyle(.secondary)
				}
				Markdown(group.description.emojized())
					.frame(maxWidth: .infinity, alignment: .leading)
			}
			
			Section {
				NavigationLink(destination: IssuesLoader(groupId: group.id)) {
					Label(title: {
						Text("Issues")
					}, icon: {
						Image(systemName: "smallcircle.circle")
							.foregroundStyle(.green)
					})
				}.foregroundStyle(.primary)
				
				NavigationLink(destination: MergeLoader(groupId: group.id)) {
					Label(title: {
						Text("Merge Requests")
					}, icon: {
						Image(systemName: "arrow.triangle.pull")
							.foregroundStyle(.blue)
					})
				}.foregroundStyle(.primary)
				
				DisclosureGroup(content: {
					NavigationLink("Members", destination: MemberLoader(groupId: group.id))
					NavigationLink("Labels", destination: LabelsLoader(groupId: group.id, showEmpty: true))
					NavigationLink("Milestones", destination: MilestoneLoader(groupId: group.id))
				}, label: {
					Label("Manage", systemImage: "person.2")
						.foregroundStyle(.primary)
				})
			}
			
			Section("Projects") {
				ProjectListView(projects: group.projects)
			}
		}.refreshable {
			if let temp = await updateFunction() {
				group = temp
			}
		}.toolbar {
			AsyncButton(systemImage: "square.and.arrow.up") {
				await URL(string: group.webUrl)!.share()
			}
		}.navigationTitle(group.name)
			.navigationBarTitleDisplayMode(.inline)
	}
}

struct GroupView_Previews: PreviewProvider {
	static var previews: some View {
		GroupView(group: Group(id: 59430464, webUrl: "https://gitlab.com/groups/mc-webshop", name: "mc-webshop", description: "Collection of repositories for the Minecraft Webshop Plugin", visibility: "public", avatarUrl: "https://gitlab.com/uploads/-/system/group/avatar/59430464/server-icon.png", projects: [], createdAt: Date()), updateFunction: { nil })
	}
}
