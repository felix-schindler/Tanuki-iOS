//
//  AccountView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct AccountView: View {
	@State var user: User? = nil
	@State var status: UserStatus? = nil
	@State var noConnection: Bool = false
	
	@State var showInfo: Bool = false
	@State var showSettings: Bool = false
	
	var body: some View {
		NavigationView {
			VStack(alignment: .leading) {
				if (user != nil) {
					HStack {
						AsyncImage(url: URL(string: user!.avatarUrl)) { image in
							image
								.resizable()
								.scaledToFit()
								.cornerRadius(10)
						} placeholder: {
							ProgressView()
						}.frame(width: 50, height: 50)
						VStack {
							Text(user!.name)
								.frame(maxWidth: .infinity, alignment: .leading)
							Text("@\(user!.username)")
								.foregroundColor(.secondary)
								.frame(maxWidth: .infinity, alignment: .leading)
						}
					}
					if (status != nil) {
						VStack {
							Text("Status")
								.font(.headline)
								.frame(maxWidth: .infinity, alignment: .leading)
							HStack {
								Text((":" + status!.emoji + ":").emojized())
								Text(status!.message)
									.frame(maxWidth: .infinity, alignment: .leading)
							}
						}.padding(.vertical, 5)
					}
					if (user!.bio != "") {
						VStack {
							Text("Bio")
								.font(.headline)
								.frame(maxWidth: .infinity, alignment: .leading)
							Text(user!.bio)
								.frame(maxWidth: .infinity, alignment: .leading)
						}.padding(.vertical, 5)
					}
					if (user!.location != "") {
						HStack {
							Image(systemName: "mappin.circle")
							Text(user!.location)
						}
					}
					if (user!.publicEmail != "") {
						HStack {
							Image(systemName: "envelope")
							Text(user!.publicEmail)
						}
					}
					if (user!.websiteUrl != "") {
						HStack {
							Image(systemName: "paperclip.circle")
							Link(user!.websiteUrl, destination: URL(string: user!.websiteUrl)!)
						}
					}
					HStack {
						Image(systemName: "person.2")
						Text("\(user!.followers) followers · \(user!.following) following")
					}
					ContributionLoader(username: user!.username)
				} else {
					if (noConnection) {
						Text("Failed to load, please check your internet connection and your token")
							.foregroundColor(.red)
					} else {
						Spacer()
						ProgressView("Loading")
					}
				}
				Spacer()
			}.padding()
				.onAppear {
					Task.init {
						await getUser()
						await getStatus()
					}
				}.toolbar {
					ToolbarItemGroup(placement: .navigationBarTrailing) {
						Button (action: {showInfo = true}) {
							Image(systemName: "info.circle")
						}
						Button (action: {showSettings = true}) {
							Image(systemName: "gearshape")
						}
					}
				}.sheet(isPresented: $showSettings) {
					SettingsView()
				}.sheet(isPresented: $showInfo) {
					InfoView()
				}.navigationTitle("Account")
		}.navigationViewStyle(StackNavigationViewStyle())
	}
	
	private func getUser() async -> Void {
		user = await API.get(type: User.self, endpoint: "user")
		noConnection = user == nil
	}
	
	private func getStatus() async -> Void {
		status = await API.get(type: UserStatus.self, endpoint: "user/status")
		noConnection = status == nil
	}
}

struct AccountView_Previews: PreviewProvider {
	static var previews: some View {
		AccountView()
	}
}
