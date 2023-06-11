//
//  UserSmallListView.swift
//  GitLab
//
//  Created by Felix Schindler on 19.03.23.
//

import SwiftUI

struct UserSmallListView: View {
	@State var users: [UserSmall]
	
	var body: some View {
		if (users.isEmpty) {
			Text("There are no users")
		} else {
			ForEach(users, id: \.id) { user in
				NavigationLink(destination: UserLoader(id: user.id)) {
					HStack {
						if let avatarUrl = URL.fromAvatar(user.avatarUrl) {
							AvatarImage(url: avatarUrl)
						}
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
	}
}

struct UserSmallListView_Previews: PreviewProvider {
	static var previews: some View {
		UserSmallListView(users: [
			UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"),
			UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"),
			UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"),
			UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png")
		])
	}
}
