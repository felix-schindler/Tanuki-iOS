//
//  CurrentUserLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.02.24.
//

import GitLabAPI
import SwiftUI

extension UserStruct {
	init(user: User_User) {
		self.init(
			id: user.id ?? "",
			avatarUrl: user.avatarUrl,
			name: user.name ?? "",
			username: user.username ?? "",
			bot: user.bot == "true",
			pronouns: user.pronouns,
			state: UserState(rawValue: user.state ?? "active") ?? .active,
			status: user.status.map { UserStatus(emoji: $0.emoji, message: $0.message) },
			bio: user.bio,
			location: user.location,
			jobTitle: user.jobTitle,
			organization: user.organization,
			discord: user.discord,
			twitter: user.twitter,
			linkedin: user.linkedin,
			publicEmail: user.publicEmail,
			groupCount: Int(user.groupCount ?? ""),
			createdAt: user.createdAt,
			webUrl: user.webUrl ?? ""
		)
	}
}

struct CurrentUserLoader: View {

	@State var user: Result<UserStruct, Error>? = nil

	private func loadUser() {
		Task {
			do {
				let currentUser = try await Network.shared.service.fetchCurrentUser()
				let fullUser = try await Network.shared.service.fetchUser(username: currentUser.username ?? "")
				self.user = .success(UserStruct(user: fullUser))
			} catch let error {
				self.user = .failure(error)
				Notify.status(.error)
			}
		}
	}

	private func reloadUser() async {
		do {
			let currentUser = try await Network.shared.service.fetchCurrentUser(strategy: .networkOnly)
			let fullUser = try await Network.shared.service.fetchUser(username: currentUser.username ?? "", strategy: .networkOnly)
			self.user = .success(UserStruct(user: fullUser))
			Notify.status(.success)
		} catch let error {
			self.user = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if let user {
				switch user {
				case .success(let user):
					UserView(user, isSelf: true)
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading Profile", systemImage: "person")
			}
		}.onAppear {
			loadUser()
		}.refreshable {
			await reloadUser()
		}.toolbar {
			ToolbarItem(placement: .topBarLeading) {
				NavigationLink(
					destination: SettingsView(),
					label: {
						Label("Settings", systemImage: "gear")
					})
			}

			ToolbarItem(placement: .topBarTrailing) {
				if let user, case .success(let user) = user,
					let url = URL(string: user.webUrl)
				{
					ShareButton(url)
				}
			}
		}
	}
}
