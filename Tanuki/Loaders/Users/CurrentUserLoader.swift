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

	@State
	private var showSettings = false

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
						Text(loadFailedMsg)
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

			RoundIconButton("Show settings", icon: "gear") {
				showSettings = true
				Haptics.shared.play(.light)
			}
		}.sheet(isPresented: $showSettings) {
			SettingsView()
		}.navigationTitle("Account")
	}
}

#Preview {
	NavigationStack {
		CurrentUserLoader()
	}
}
