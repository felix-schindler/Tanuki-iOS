//
//  CurrentUserLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.02.24.
//

import GitLabAPI
import SwiftUI

struct CurrentUserLoader: View {
	public private(set) var showSetup: Binding<Bool>

	@State
	private var user: Result<CurrentUserQuery.Data.CurrentUser, Error>? = nil

	private func loadUser() async {
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
			if let user {
				switch user {
				case .success(let user):
					UserView(user)
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading Profile", systemImage: "person")
			}
		}.onAppear {
			Task {
				await loadUser()
			}
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
				HStack {
					if let user, case .success(let user) = user,
						let url = URL(string: user.webUrl)
					{
						ShareButton(url)
					}

					AsyncButton(
						"Sign out",
						systemImage: "rectangle.portrait.and.arrow.right",
						role: .destructive
					) {
						API.host = "gitlab.com"
						API.token = ""
						Notify.status(.success, "Logged out")
						do {
							URLCache.shared.removeAllCachedResponses()
							URLCache.avatarCache.removeAllCachedResponses()
							try await Network.shared.apollo.store.clearCache()
							self.showSetup.wrappedValue = true
						} catch let error {
							Notify.status(
								.error,
								"Failed to log out",
								error.localizedDescription
							)
						}
					}.tint(.red)
				}
			}
		}
	}
}

#Preview {
	NavigationView {
		CurrentUserLoader(showSetup: .constant(false))
	}
}
