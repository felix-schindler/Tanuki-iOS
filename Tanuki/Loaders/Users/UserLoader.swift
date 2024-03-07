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
	private var user: UserQuery.Data.User? = nil

	@State
	private var loadFailed = false

	init(username: String) {
		self.username = username
	}

	private func loadUser() {
		Network.shared.apollo.fetch(
			query: UserQuery(username: self.username)
		) { result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting namespace...")
				user = graphQLResult.data?.user
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
					if loadFailed {
						Text(loadFailedMsg)
					} else {
						ProgressView("Loading user \(self.username)")
					}
				}.frame(maxWidth: .infinity)
			}
		}.onAppear {
			loadUser()
		}.refreshable {
			loadUser()
		}.toolbar {
			if let url = URL(string: user?.webUrl ?? "") {
				ShareButton(url)
			}
		}.navigationTitle("User")
	}
}

#Preview {
	UserLoader(username: "felix-schindler")
}
