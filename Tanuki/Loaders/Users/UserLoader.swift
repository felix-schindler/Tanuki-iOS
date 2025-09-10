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

	@State
	private var user: Result<UserQuery.Data.User, Error>? = nil

	@State
	private var isLoading = false

	init(username: String) {
		self.username = username
	}

	private func loadUser() {
		isLoading = true

		defer {
			isLoading = false
		}

		do {
			let responses = try Network.shared.apollo.fetch(
				query: UserQuery(username: self.username), cachePolicy: .cacheAndNetwork)

			Task {
				for try await response in responses {
					if let user = response.data?.user {
						self.user = .success(user)
						Notify.status(.success)
					} else if let errors = response.errors {
						for error in errors {
							Notify.status(.error, error.localizedDescription)
						}
					}
				}
			}
		} catch let error {
			self.user = .failure(error)
			Notify.status(.error)
		}
	}

	private func reloadUser() async {
		do {
			let response = try await Network.shared.apollo.fetch(
				query: UserQuery(username: self.username), cachePolicy: .networkOnly)

			if let user = response.data?.user {
				self.user = .success(user)
			}

			Notify.status(.success)
		} catch let error {
			self.user = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if isLoading {
				ProgressView("Loading user \(self.username)")
			} else if let user {
				switch user {
				case .success(let user):
					UserView(user)
				case .failure(let error):
					FailedView(error)
				}
			}
		}.onAppear {
			loadUser()
		}.refreshable {
			await reloadUser()
		}.toolbar {
			if let user {
				switch user {
				case .success(let user):
					if let url = URL(string: user.webUrl) {
						ShareButton(url)
					}
				case .failure:
					EmptyView()
				}
			}
		}.navigationTitle("User")
	}
}

#Preview {
	UserLoader(username: "felix-schindler")
}
