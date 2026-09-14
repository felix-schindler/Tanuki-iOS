//
//  SmallGroupView.swift
//  Tanuki
//
//  Created by Felix Schindler on 12.10.25.
//

import GitLabAPI
import SwiftUI

private struct _Group: GitLabAPI.Group {
	var avatarUrl: String?
	var _name: String?
	var fullPath: String
	var visibility: String?
	var groupMembersCount: Int
	var projectsCount: Int
	var _accessLevel: String?
}

struct SmallGroupView: View {
	public let group: GitLabAPI.Group

	public var body: some View {
		NavigationLink(
			destination: GroupLoader(fullPath: group.fullPath),
			label: {
				HStack {
					if let url = URL.fromAvatar(group.avatarUrl) {
						AvatarImage(url, size: .medium)
					}

					VStack(alignment: .leading) {
						HStack {
							if let visibility = group.visibility {
								VisibilityIcon(visibility)
							}
							if let groupName = group._name?.emojized() {
								Text(groupName)
							} else {
								Text(group.fullPath)
							}
						}

						HStack(spacing: 10) {
							HStack(spacing: 2) {
								Image(
									systemName: "person.2")
								Text(
									String(
										group
											.groupMembersCount
									))
							}

							HStack(spacing: 2) {
								Image(
									systemName:
										"app.gift.fill")
								Text(
									String(
										group.projectsCount)
								)
							}
						}.font(.footnote)
					}

					if let accessLevel = group._accessLevel {
						Spacer()
						PillView(accessLevel.replacing("_", with: " ").capitalized)
							.font(.footnote)
					}
				}
			}
		)
	}
}
