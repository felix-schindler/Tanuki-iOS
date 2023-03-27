//
//  UserSmallListView.swift
//  GitLab
//
//  Created by Felix Schindler on 19.03.23.
//

import SwiftUI

struct UserSmallListView: View {
	@State var users: [UserSmall]
	@State var updateFunction: () async -> [UserSmall]?
	
	var body: some View {
		List {
			if (users.isEmpty) {
				Text("There are no users")
			} else {
				ForEach(users, id: \.id) { user in
					NavigationLink(destination: UserLoader(id: user.id)) {
						HStack {
							AsyncImage(url: URL(string: user.avatarUrl)) { image in
								image
									.resizable()
									.scaledToFit()
									.cornerRadius(10)
							} placeholder: {
								ProgressView()
							}.frame(width: 50, height: 50)
							VStack(alignment: .leading) {
								Text(user.name)
								Text("@\(user.username)")
									.font(.callout)
									.foregroundColor(.secondary)
							}
						}
					}
				}
			}
		}.refreshable {
			let temp = await updateFunction()
			if (temp != nil) {
				users = temp!
			}
		}.navigationTitle("Users")
	}
}

struct UserSmallListView_Previews: PreviewProvider {
	static var previews: some View {
		UserSmallListView(users: [
			UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"),
			UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"),
			UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"),
			UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png")
		], updateFunction: { nil })
	}
}
