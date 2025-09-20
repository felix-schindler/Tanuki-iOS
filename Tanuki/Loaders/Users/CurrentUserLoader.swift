//
//  CurrentUserLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.02.24.
//

import GitLabAPI
import SwiftUI

struct CurrentUserLoader: View {
	@State
	private var user: Result<CurrentUserQuery.Data.CurrentUser, Error>? = nil

	@State
	private var isLoading = false

	private func loadUser() async {
		isLoading = true

		defer {
			isLoading = false
		}

		do {
			let responses = try Network.shared.apollo.fetch(
				query: CurrentUserQuery(), cachePolicy: .cacheAndNetwork)

			Task {
				for try await response in responses {
					if let user = response.data?.currentUser {
						self.user = .success(user)
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
				query: CurrentUserQuery(), cachePolicy: .networkOnly)

			if let user = response.data?.currentUser {
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
				ProgressView("Loading current user...")
			} else if let user {
				switch user {
				case .success(let user):
					UserView(user)
				case .failure(let error):
					FailedView(error)
				}
			}
		}.onAppear {
			Task {
				await loadUser()
			}
		}.refreshable {
			await reloadUser()
		}.toolbar {
			switch self.user {
			case .success(let user):
				if let url = URL(string: user.webUrl) {
					ShareButton(url)
				}
			default:
				EmptyView()
			}

			Button(
				"Sign out", systemImage: "rectangle.portrait.and.arrow.right", role: .destructive
			) {
				API.host = "gitlab.com"
				API.token = ""
				Notify.status(.success, "Logged out")
			}.tint(.red)
		}.navigationTitle("Account")
	}
}

#Preview {
	NavigationStack {
		CurrentUserLoader()
	}
}
