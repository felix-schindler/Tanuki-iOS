//
//  SingleUserView.swift
//  GitLab
//
//  Created by Felix Schindler on 20.03.23.
//

import SwiftUI

struct SingleUserView: View {
	@State var user: User
	@State var status: UserStatus
	
	var body: some View {
		Section {
			HStack {
				if let avatarUrl = URL.fromAvatar(user.avatarUrl) {
					AvatarImage(url: avatarUrl)
				}
				VStack(alignment: .leading) {
					HStack {
						if (!user.name.isEmpty) {
							Text(user.name)
						}
						if (!(user.pronouns?.isEmpty ?? true)) {
							Text(user.pronouns!)
								.foregroundStyle(.secondary)
								.font(.callout)
						}
					}
					HStack(spacing: 2) {
						if (user.bot) {
							Text("🤖")
						}
						Text("@\(user.username)")
							.foregroundStyle(.secondary)
					}
				}
				Spacer()
				VStack(alignment: .trailing) {
					Text("ID: \(String(user.id))")
						.textSelection(.enabled)
					if let createdAt = user.createdAt {
						Text(createdAt.toDateString())
					}
				}.font(.footnote)
					.foregroundStyle(.secondary)
			}
			
			let showEmoji = (status.emoji != nil && status.emoji! != "")
			let showMessage = (status.message != nil && status.message != "")
			if (showEmoji || showMessage) {
				HStack(spacing: 2) {
					if (showEmoji) {
						Text(":\(status.emoji!):".emojized())
					}
					if (showMessage) {
						Text(status.message!)
					}
				}
			}
			
			if (!(user.bio?.isEmpty ?? true)) {
				Text(user.bio!.emojized())
			}
			
			if (!(user.location?.isEmpty ?? true)) {
				Label(user.location!, systemImage: "mappin.and.ellipse")
					.foregroundStyle(.primary)
			}
			
			if (!(user.localTime?.isEmpty ?? true)) {
				Label(user.localTime!, systemImage: "clock")
					.foregroundStyle(.primary)
			}
			
			let workStr = user.workInformation ?? "\(user.jobTitle ?? "") \(user.organization ?? "")".trim()
			if (!workStr.isEmpty) {
				Label(workStr, systemImage: "briefcase")
					.foregroundStyle(.primary)
			}
			
			if (!(user.publicEmail?.isEmpty ?? true)) {
				Label(user.publicEmail!, systemImage: "envelope")
					.textSelection(.enabled)
			}

			if (user.websiteUrl?.isNotEmpty ?? false) {
				if let websiteUrl = URL(string: user.websiteUrl!) {
					Link(
						destination: websiteUrl,
						label: {
							Label(user.websiteUrl!, systemImage: "paperclip")
								.foregroundStyle(.primary)
						}
					)
				}
			}
			
			let showSkype =     user.skype?.isNotEmpty ?? false
			let showIn =        user.linkedin?.isNotEmpty ?? false
			let showTwitter =   user.twitter?.isNotEmpty ?? false
			let showDiscord =   user.discord?.isNotEmpty ?? false
			
			if (showSkype || showIn || showTwitter || showDiscord) {
				HStack {
					Image(systemName: "person.line.dotted.person")
					ScrollView(.horizontal) {
						HStack {
							if (showSkype) {
								Link(user.skype!, destination: URL(string: "skype:\(user.skype!)")!)
							}
							if (showIn) {
								Text("linkedIn: \(user.linkedin!)")
									.textSelection(.enabled)
							}
							if (showTwitter) {
								Label(user.twitter!, systemImage: "bird")
									.textSelection(.enabled)
							}
							if (showDiscord) {
								Text("👾 \(user.discord!)")
									.textSelection(.enabled)
							}
						}
					}
				}
			}
			
			Label("\(user.followers ?? 0) followers · \(user.following ?? 0) following", systemImage: "person.2")
				.foregroundStyle(.primary)
		}
		
		Section {
			NavigationLink("Activity", destination: EventsView(userId: user.id))
			NavigationLink("Projects", destination: ProjectsLoader(userId: user.id))
		}
	}
}

struct SingleUserView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			SingleUserView(
				user: User(
					id: 9005085,
					username: "felix-schindler",
					name: "Felix",
					state: "active",
					webUrl: "https://gitlab.com/felix-schindler",
					bot: true,
					avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png",
					createdAt: Date(),
					bio: "Studying computer science as a German-Chinese double degree",
					location: "Stuttgart, Germany",
					publicEmail: "",
					skype: "",
					linkedin: "",
					twitter: "",
					discord: "",
					websiteUrl: "https://schindlerfelix.de",
					organization: "WUD",
					jobTitle: "Software Developer",
					pronouns: "he/him",
					workInformation: "Software Developer at WUD",
					followers: 0,
					following: 0,
					localTime: "8:51 AM",
					isFollowed: false
				),
				status: UserStatus(
					emoji: "+1",
					message: "This is a status."
				)
			)
		}
	}
}
