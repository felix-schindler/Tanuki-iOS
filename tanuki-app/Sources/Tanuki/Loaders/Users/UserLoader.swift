//
//  UserLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.02.24.
//

import GitLabAPI
import SwiftUI

struct UserLoader: View {
	private let username: String

	@State var user: Result<UserStruct, Error>? = nil

	init(username: String) {
		self.username = username
	}

	private func loadUser() {
		Task {
			do {
				let user = try await Network.shared.service.fetchUser(username: self.username)
				self.user = .success(UserStruct(user: user))
			} catch let error {
				self.user = .failure(error)
				Notify.status(.error)
			}
		}
	}

	private func reloadUser() async {
		do {
			let user = try await Network.shared.service.fetchUser(username: self.username)
			self.user = .success(UserStruct(user: user))
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
					UserView(user, isSelf: false)
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading user \(self.username)", systemImage: "person")
			}
		}.onAppear {
			loadUser()
		}.refreshable {
			await reloadUser()
		}.toolbar {
			if let user, case .success(let user) = user,
				let url = URL(string: user.webUrl)
			{
				ShareButton(url)
			}
		}
	}
}

#Preview {
	UserLoader(username: "felix-schindler")
}
