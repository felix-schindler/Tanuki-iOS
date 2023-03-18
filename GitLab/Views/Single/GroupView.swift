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
		VStack(alignment: .leading) {
			VStack {
				HStack {
					if (group.avatarUrl != nil) {
						AsyncImage(url: URL(string: group.avatarUrl!)) { phase in
							switch phase {
							case .empty:
								ProgressView()
							case .success(let image):
								image
									.resizable()
									.scaledToFit()
									.cornerRadius(10)
							default:
								Image(systemName: "exclamationmark.icloud")
									.resizable()
									.scaledToFit()
							}
						}.frame(width: 50, height: 50, alignment: .leading)
					}
					VStack(alignment: .leading) {
						HStack(spacing: 5) {
							if (group.visibility == "private") {
								Image(systemName: "lock")
							} else if (group.visibility == "internal") {
								Image(systemName: "shield.lefthalf.filled")
							} else if (group.visibility == "public") {
								Image(systemName: "globe")
							}
							Text(group.name)
						}
						Text("ID: " + String(group.id))
							.font(.caption)
							.foregroundColor(.secondary)
							.padding(.bottom, 0.5)
					}
				}.frame(maxWidth: .infinity, alignment: .leading)
				Markdown(group.description.emojized())
			}.padding()
			// FIXME: This should actually load the groups projects
			ProjectListView(projects: group.projects, updateFunction: { return group.projects })
			Spacer()
		}.refreshable(action: {
			Task.init {
				let temp = await updateFunction()
				if (temp != nil) {
					group = temp!
				}
			}
		}).navigationTitle(group.name)
			.navigationBarTitleDisplayMode(.inline)
	}
}

struct GroupView_Previews: PreviewProvider {
	static var previews: some View {
		GroupView(group: Group(id: 59430464, name: "mc-webshop", description: "Collection of repositories for the Minecraft Webshop Plugin", visibility: "public", avatarUrl: "https://gitlab.com/uploads/-/system/group/avatar/59430464/server-icon.png", projects: []), updateFunction: { nil })
	}
}
