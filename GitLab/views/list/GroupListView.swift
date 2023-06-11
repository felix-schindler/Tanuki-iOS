//
//  GroupListView.swift
//  GitLab
//
//  Created by Felix Schindler on 24.01.22.
//

import SwiftUI

struct GroupListView: View {
	@State var groups: [SmallGroup]
	@State var updateFunction: () async -> [SmallGroup]?
	
	var body: some View {
		if (groups.isEmpty) {
			Text("There are no groups")
		} else {
			ForEach(groups, id: \.id) { group in
				NavigationLink(destination: GroupLoader(id: group.id)) {
					HStack {
						if (group.avatarUrl != nil) {
							AvatarImage(url: URL(string: group.avatarUrl!))
						}
						VStack(alignment: .leading) {
							HStack(spacing: 2) {
								if (group.visibility == "private") {
									Image(systemName: "lock")
								} else if (group.visibility == "internal") {
									Image(systemName: "shield.lefthalf.filled")
								} else if (group.visibility == "public") {
									Image(systemName: "globe")
								}
								Text(group.name)
									.fontWeight(.medium)
							}
							if (!(group.description?.isEmpty ?? true)) {
								Text(group.description!.emojized())
									.font(.footnote)
							}
						}
					}
				}
			}
		}
	}
}

struct GroupListView_Previews: PreviewProvider {
	static var previews: some View {
		GroupListView(groups: [], updateFunction: { nil })
	}
}
