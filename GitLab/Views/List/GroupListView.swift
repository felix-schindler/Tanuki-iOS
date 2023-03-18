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
			List(groups, id: \.id) { group in
				NavigationLink(destination: GroupLoader(id: group.id)) {
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
						VStack {
							HStack {
								Text(group.name)
								if (group.visibility == "private") {
									Image(systemName: "lock")
								} else if (group.visibility == "internal") {
									Image(systemName: "shield.lefthalf.filled")
								} else if (group.visibility == "public") {
									Image(systemName: "globe")
								}
							}.frame(maxWidth: .infinity, alignment: .leading)
							if (group.description != nil && group.description! != "") {
								Text(group.description!.emojized())
									.font(.footnote)
									.foregroundColor(.secondary)
									.frame(maxWidth: .infinity, alignment: .leading)
							}
						}
					}
				}
			}.refreshable {
				let temp = await updateFunction()
				if (temp != nil) {
					groups = temp!
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
