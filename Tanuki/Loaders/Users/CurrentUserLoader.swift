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
				if loadFailed {
					Text(LOAD_FAILED)
				} else {
					ProgressView("Loading current user")
						.frame(maxWidth: .infinity, alignment: .center)
				}
			}
		}.onAppear {
			loadUser()
		}.refreshable {
			loadUser()
		}.toolbar {
			if let url = URL(string: user?.webUrl ?? "") {
				ShareButton(url)
			}
		}.navigationTitle("Account")
	}
}

#Preview {
	NavigationStack {
		CurrentUserLoader()
	}
}
