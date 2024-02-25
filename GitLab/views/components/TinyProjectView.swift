//
//  TinyProjectView.swift
//  GitLab
//
//  Created by Felix Schindler on 13.06.23.
//

import SwiftUI

struct TinyProjectView: View {
	@State var project: Project
	
	var body: some View {
		NavigationLink(destination: ProjectView(project: project)) {
			HStack {
				if let avatarUrl = URL.fromAvatar(project.avatarUrl ?? project.namespace.avatarUrl) {
					AvatarImage(url: avatarUrl, size: .small)
				}
				Text(project.nameWithNamespace)
				Spacer()
				VisibilityIcon(project.visibility)
			}
		}
	}
}

#Preview {
	NavigationStack {
		VStack {
			TinyProjectView(
				project: Project(
					id: 33025310,
					description: "The native SwiftUI GitLab client for iOS and iPadOS.",
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
		}.padding()
	}
}
