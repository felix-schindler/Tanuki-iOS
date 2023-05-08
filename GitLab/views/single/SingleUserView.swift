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
		List {
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
					HStack {
						if (user.name != "") {
							Text(user.name)
						}
						if (!(user.pronouns?.isEmpty ?? true)) {
							Text(user.pronouns!)
								.foregroundColor(.secondary)
								.font(.callout)
						}
					}
					HStack(spacing: 2) {
						if (user.bot) {
							Text("🤖")
						}
						Text("@\(user.username)")
							.foregroundColor(.secondary)
					}
				}
				Spacer()
				VStack(alignment: .trailing) {
					Text("ID: \(String(user.id))")
						.textSelection(.enabled)
					Text(user.createdAt.toDateString())
				}.font(.footnote)
					.foregroundColor(.secondary)
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
			
			if (!user.bio.isEmpty) {
				Text(user.bio.emojized())
			}
			
			if (!(user.location?.isEmpty ?? true)) {
				Label(user.location!, systemImage: "mappin.and.ellipse")
					.foregroundColor(.primary)
			}
			
			if (!(user.localTime?.isEmpty ?? true)) {
				Label(user.localTime!, systemImage: "clock")
					.foregroundColor(.primary)
			}
			
			let workStr = user.workInformation ?? "\(user.jobTitle) \(user.organization)".trim()
			if (!workStr.isEmpty) {
				Label(workStr, systemImage: "briefcase")
					.foregroundColor(.primary)
			}
			
			if (!(user.publicEmail?.isEmpty ?? true)) {
				Label(user.publicEmail!, systemImage: "envelope")
					.textSelection(.enabled)
			}
			
			if (!user.websiteUrl.isEmpty) {
				Link(destination: URL(string: user.websiteUrl)!, label: {
					Label(user.websiteUrl, systemImage: "paperclip")
						.foregroundColor(.primary)
				})
			}
			
			let showSkype =		!user.skype.isEmpty
			let showIn =			!user.linkedin.isEmpty
			let showTwitter =	!user.twitter.isEmpty
			let showDiscord =	!user.discord.isEmpty
			
			if (showSkype || showIn || showTwitter || showDiscord) {
				HStack {
					Image(systemName: "person.line.dotted.person")
					ScrollView(.horizontal) {
						HStack {
							if (showSkype) {
								Link(user.skype, destination: URL(string: "skype:\(user.skype)")!)
							}
							if (showIn) {
								Text("linkedIn: \(user.linkedin)")
									.textSelection(.enabled)
							}
							if (showTwitter) {
								Label(user.twitter, systemImage: "bird")
									.textSelection(.enabled)
							}
							if (showDiscord) {
								Text("👾 \(user.discord)")
									.textSelection(.enabled)
							}
						}
					}
				}
			}
			
			Label("\(user.followers ?? 0) followers · \(user.following ?? 0) following", systemImage: "person.2")
				.foregroundColor(.primary)
			
			Section {
				NavigationLink("Activity", destination: EventsView(userId: user.id))
				NavigationLink("Projects", destination: ProjectsLoader(userId: user.id))
			}
		}.toolbar {
			AsyncButton(systemImage: "square.and.arrow.up") {
				await URL(string: user.webUrl)!.share()
			}
		}.navigationTitle(user.name.isEmpty ? user.username : user.name)
	}
}

struct SingleUserView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			SingleUserView(user: User(id: 9005085, username: "felix-schindler", name: "Felix", state: "active", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png", webUrl: "https://gitlab.com/felix-schindler", createdAt: Date(), bio: "Studying computer science as a German-Chinese double degree", bot: true, location: "Stuttgart, Germany", publicEmail: "", skype: "", linkedin: "", twitter: "", discord: "", websiteUrl: "https://schindlerfelix.de", organization: "WUD", jobTitle: "Software Developer", pronouns: "he/him", workInformation: "Software Developer at WUD", followers: 0, following: 0, localTime: "8:51 AM", isFollowed: false), status: UserStatus(emoji: "+1", message: "This is a status."))
		}
	}
}
