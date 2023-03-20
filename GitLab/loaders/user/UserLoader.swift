//
//  UserLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 20.03.23.
//

import SwiftUI

struct UserLoader: View {
	// Parameters
	/// UserID
	@State var id: Int = 0
	/// Whether to load the logged in user. When true, no ID needed
	@State var loadSelf = false
	
	@State var user: User? = nil
	// @State var status: UserStatus? = nil
	@State var loadFailed = false
	
	var body: some View {
		VStack {
			if (user != nil) {
				SingleUserView(user: user!)
			} else {
				Spacer()
				if (loadFailed) {
					Text("Failed to load, please check your internet connection and your token")
				} else {
					ProgressView()
				}
				Spacer()
			}
		}.onAppear() {
			Task.init {
				user = await loadUser()
				loadFailed = (user == nil)
				// status = await loadStatus()
				// loadFailed = (user == nil || status == nil)
			}
		}
	}
	
	private func loadUser() async -> User? {
		return await API.get(type: User.self, endpoint: loadSelf ? "user" : "users/\(id)")
	}
	
	private func loadStatus() async -> UserStatus? {
		return await API.get(type: UserStatus.self, endpoint: loadSelf ? "user/status" : "users/\(id)/status")
	}
}

struct UserLoader_Previews: PreviewProvider {
	static var previews: some View {
		UserLoader()
	}
}
