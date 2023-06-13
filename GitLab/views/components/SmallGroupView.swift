//
//  GroupListView.swift
//  GitLab
//
//  Created by Felix Schindler on 24.01.22.
//

import SwiftUI
import MarkdownUI

struct SmallGroupView: View {
	@State var group: SmallGroup
	
	var body: some View {
		NavigationLink(destination: GroupLoader(id: group.id)) {
			HStack {
				if let avatarUrl = URL.fromAvatar(group.avatarUrl) {
					AvatarImage(url: avatarUrl)
				}
				VStack(alignment: .leading) {
					HStack(spacing: 2) {
						VisibilityIcon(group.visibility)
						Text(group.name)
							.fontWeight(.medium)
					}
					if (!(group.description?.isEmpty ?? true)) {
						Markdown(group.description!.emojized())
							.markdownTheme(.small)
					}
				}
			}
		}
	}
}

struct SmallGroupView_Previews: PreviewProvider {
	static var previews: some View {
		GroupListView(groups: [], updateFunction: { nil })
	}
}
