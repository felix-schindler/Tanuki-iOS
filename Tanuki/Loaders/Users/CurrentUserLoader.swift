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
	private var user: CurrentUserQuery.Data.CurrentUser? = nil

	@State
	private var loadFailed = false

	private func loadUser() {
		Network.shared.apollo.fetch(
			query: CurrentUserQuery()
		) { result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting namespace...")
				user = graphQLResult.data?.currentUser
			case .failure(let error):
				print("Failure! Error: \(error)")
				loadFailed = true
			}
		}
	}

	public var body: some View {
		List {
			if let user {
				UserView(user)
			} else {
				VStack {
					Image(systemName: "person")
						.resizable()
						.scaledToFit()
						.foregroundStyle(Color.accentColor)
						.frame(width: 50, height: 50)
					if loadFailed {
						Text(failedToLoad)
					} else {
						ProgressView("Loading current user...")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadUser()
		}.refreshable {
			loadUser()
		}.toolbar {
			if let url = URL(string: user?.webUrl ?? "") {
				ShareButton(url)
			}

			Button(
				role: .destructive,
				action: {
					API.host = "gitlab.com"
					API.token = ""
					Notify.status(.success, "Logged out")
				},
				label: {
					Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right")
				}
			).tint(.red)
		}.navigationTitle("Account")
	}
}

#Preview {
	NavigationStack {
		CurrentUserLoader()
	}
}
