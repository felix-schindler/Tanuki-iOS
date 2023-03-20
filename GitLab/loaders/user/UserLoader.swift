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
	@State var status: UserStatus? = nil
	@State var loadFailed = false
	
	var body: some View {
		VStack {
			if (user != nil && status != nil) {
				SingleUserView(user: user!, status: status!)
					.refreshable {
						await loadUserAndStatus()
					}
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
				await loadUserAndStatus()
			}
		}
	}
	
	private func loadUserAndStatus() async -> Void {
		user = await API.get(type: User.self, endpoint: loadSelf ? "user" : "users/\(id)")
		status = await API.get(type: UserStatus.self, endpoint: loadSelf ? "user/status" : "users/\(id)/status")
		loadFailed = (user == nil || status == nil)
	}
}

struct UserLoader_Previews: PreviewProvider {
	static var previews: some View {
		UserLoader()
	}
}
