//
//  SmallProjectView.swift
//  GitLab
//
//  Created by Felix Schindler on 13.06.23.
//

import SwiftUI
import MarkdownUI

struct SmallProjectView: View {
	@State var project: Project
	
	var body: some View {
		NavigationLink(destination: ProjectView(project: project)) {
			HStack {
				if let avatarUrl = URL.fromAvatar(project.avatarUrl ?? project.namespace.avatarUrl) {
					AvatarImage(url: avatarUrl)
				}
				VStack(alignment: .leading, spacing: 2) {
					HStack(spacing: 2) {
						VisibilityIcon(project.visibility)
						Text(project.nameWithNamespace)
							.fontWeight(.medium)
						if let accessLevel = project.permissions?.projectAccess?.accessLevel {
							Spacer()
							Text(Project.accessRole(accessLevel))
								.font(.caption)
								.padding(.horizontal, 6)
								.padding(.vertical, 4)
								.background(Color(.systemGray3))
								.cornerRadius(10)
						}
					}
					if (!(project.description?.isEmpty ?? true)) {
						Markdown(project.description!.emojized())
							.multilineTextAlignment(.leading)
							.markdownTheme(.small)
					}
					ScrollView(.horizontal) {
						HStack {
							HStack(spacing: 2) {
								Image(systemName: "star")
								Text(String(project.starCount))
							}
							
							if (project.forksCount != nil) {
								HStack(spacing: 2) {
									Image(systemName: "arrow.branch")
									Text(String(project.forksCount!))
								}
							}
							
							if (project.issuesEnabled && project.openIssuesCount != nil) {
								HStack(spacing: 2) {
									Image(systemName: "smallcircle.circle")
									Text(String(project.openIssuesCount!))
								}
							}
							
							if (!project.tagList.isEmpty) {
								HStack(spacing: 2) {
									Image(systemName: "tag")
									ForEach(project.tagList, id: \.hashValue) { tag in
										Text(tag)
											.padding(.horizontal, 4)
											.padding(.vertical, 2)
											.foregroundStyle(.primary)
											.background(Color(.systemGray5))
											.cornerRadius(7.5)
									}
								}.font(.caption2)
							}
						}
					}
					.padding(.top, 2)
					.font(.caption)
					.foregroundStyle(.secondary)
				}
			}
		}
	}
}

struct SmallProjectView_Previews: PreviewProvider {
	static var previews: some View {
		SmallProjectView(
			project: Project(
				id: 33025310,
				description: "The native SwiftUI `GitLab client` for iOS and iPadOS.",
				name: "Tanuki for GitLab",
				nameWithNamespace: "Felix / Tanuki for GitLab",
				pathWithNamespace: "felix-schindler/gitlab-ios",
				defaultBranch: "main",
				tagList: ["Tanuki", "iOS", "iPadOS", "SwiftUI", "GitLab", "App", "Client"],
				webUrl: "https://gitlab.com/felix-schindler/gitlab-ios",
				readmeUrl: "https://gitlab.com/felix-schindler/gitlab-ios/-/blob/main/README.md",
				avatarUrl: "https://gitlab.com/uploads/-/system/project/avatar/33025310/Tanuki-200kb.png",
				forksCount: 0,
				starCount: 1,
				namespace: Namespace(id: 0, name: "Felix", path: "felix-schindler", avatarUrl: ""),
				visibility: "public",
				owner: UserSmall(
					id: 9005085,
					name: "Felix",
					username: "felix-schindler",
					avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"
				),
				issuesEnabled: true,
				openIssuesCount: 12,
				mergeRequestsEnabled: true,
				permissions: Permissions(
					projectAccess: Access(
						accessLevel: 50,
						notificationLevel: 3
					)
				)
			)
		)
	}
}
