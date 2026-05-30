//
//  CurrentUserLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.02.24.
//

import GitLabAPI
import SwiftUI

struct CurrentUserLoader: View {

	@State var user: Result<CurrentUserPayload, Error>? = nil

	private func loadUser() {
		Task {
			do {
				let user = try await Network.shared.service.fetchCurrentUser()
				self.user = .success(user)
			} catch let error {
				self.user = .failure(error)
				Notify.status(.error)
			}
		}
	}

	private func reloadUser() async {
		do {
			let user = try await Network.shared.service.fetchCurrentUser()
			self.user = .success(user)
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

#Preview {
	NavigationView {
		CurrentUserLoader()
	}
}
