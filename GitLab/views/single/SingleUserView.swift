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
						if (user.pronouns != nil && user.pronouns! != "") {
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
			
			if (user.bio != "") {
				Text(user.bio.emojized())
			}
			
			
			let showLocation = (user.location != nil && user.location! != "")
			let showTime = (user.localTime != nil && user.localTime! != "")
			
			if (showLocation || showTime) {
				HStack {
					if (showLocation) {
						HStack {
							Image(systemName: "mappin.and.ellipse")
							Text(user.location!)
								.textSelection(.enabled)
						}
					}
					if (showLocation && showTime) {
						Text("·")
					}
					if (showTime) {
						HStack {
							Image(systemName: "clock")
							Text(user.localTime!)
						}
					}
				}
			}
			
			
			let showWorkInfo = (user.workInformation != nil && user.workInformation != "")
			let showJob = user.jobTitle != ""
			let showOrg = user.organization != ""
			
			if (showWorkInfo || showJob || showOrg) {
				HStack {
					Image(systemName: "briefcase")
					if (showWorkInfo) {
						Text(user.workInformation!)
					} else {
						if (showJob) {
							Text(user.jobTitle)
						}
						if (showOrg) {
							Text(user.organization)
						}
					}
				}
			}
			
			if (user.publicEmail != nil && user.publicEmail! != "") {
				HStack {
					Image(systemName: "envelope")
					Text(user.publicEmail!)
						.textSelection(.enabled)
				}
			}
			
			if (user.websiteUrl != "") {
				HStack {
					Image(systemName: "paperclip")
					Link(user.websiteUrl, destination: URL(string: user.websiteUrl)!)
				}
			}
			
			
			let showSkype = (user.skype != "")
			let showIn = (user.linkedin != "")
			let showTwitter = (user.twitter != "")
			let showDiscord = (user.discord != "")
			
			if (showSkype || showIn || showTwitter || showDiscord) {
				HStack {
					Image(systemName: "person.line.dotted.person")
					ScrollView(.horizontal) {
						HStack {
							if (showSkype) {
								Text("Skype: \(user.skype)")
									.textSelection(.enabled)
							}
							if (showIn) {
								Text("linkedIn: \(user.linkedin)")
									.textSelection(.enabled)
							}
							if (showTwitter) {
								HStack(spacing: 2) {
									Image(systemName: "bird")
										.foregroundColor(.cyan)
									Text(user.twitter)
										.textSelection(.enabled)
								}
							}
							if (showDiscord) {
								Text("Discord: \(user.discord)")
									.textSelection(.enabled)
							}
						}
					}
				}
			}
			
			HStack {
				Image(systemName: "person.2")
				Text("\(user.followers) followers · \(user.following) following")
			}
			
			Section("Contributions") {
				ContributionLoader(username: user.username)
			}
		}.navigationTitle(user.name != "" ? user.name : user.username)
			.toolbar {
				ToolbarItemGroup(placement: .navigationBarTrailing) {
					AsyncButton(systemImage: "square.and.arrow.up") {
						await URL(string: user.webUrl)!.share()
					}
				}
			}
	}
}

struct SingleUserView_Previews: PreviewProvider {
	static var previews: some View {
		SingleUserView(user: User(id: 9005085, username: "felix-schindler", name: "Felix", state: "active", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png", webUrl: "https://gitlab.com/felix-schindler", createdAt: Date(), bio: "Studying computer science as a German-Chinese double degree", bot: true, location: "Stuttgart, Germany", publicEmail: "", skype: "", linkedin: "", twitter: "", discord: "", websiteUrl: "https://schindlerfelix.de", organization: "WUD", jobTitle: "Software Developer", pronouns: "he/him", workInformation: "Software Developer at WUD", followers: 0, following: 0, localTime: "8:51 AM", isFollowed: false), status: UserStatus(emoji: nil, message: "This is a status."))
	}
}
