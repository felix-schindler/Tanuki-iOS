//
//  SettingsView.swift
//  GitLab
//
//  Created by Felix Schindler on 02.11.21.
//

import SwiftUI

/// This View is meant to be used as a sheet.
/// Lets the user change the GitLab configuration (URL, Token)
struct SettingsView: View {
	@Environment(\.presentationMode)
	var presentationMode: Binding<PresentationMode>
	
	@State var url: String = API.domain     // New GitLab URL
	@State var token: String = API.token    // New GitLab Token
	
	@State var configError: Bool = false
	
	var body: some View {
		NavigationView {
			VStack {
				Spacer()
				Label("GitLab URL", systemImage: "link")
					.font(.headline)
				TextField("https://gitlab.com", text: $url)
					.padding()
					.textContentType(.URL)
					.keyboardType(.URL)
					.background(Color(.systemGray5))
					.cornerRadius(10)
				Label("Personal Access Token", systemImage: "key")
					.font(.headline)
					.padding(.top)
				TextField("glpat-4Rzq-VKwapmWqj4MfBsi", text: $token)
					.padding()
					.disableAutocorrection(true)
					.background(Color(.systemGray5))
					.cornerRadius(10)
				VStack(alignment: .leading) {
					HStack {
						Image(systemName: "checkmark.square")
						Text("api")
					}
					HStack {
						Image(systemName: "checkmark.square")
						Text("read_user")
					}
					HStack {
						Image(systemName: "checkmark.square")
						Text("read_api")
					}
					HStack {
						Image(systemName: "checkmark.square")
						Text("read_repository")
					}
					Text("The required API version is v4")
				}.padding()
					.foregroundColor(.secondary)
				Spacer()
				Button(action: {
					Task {
						configError = await !validGitConfig()
						if (!configError) {
							self.presentationMode.wrappedValue.dismiss()
						}
					}
				}, label: {
					Text("Save configuration")
						.fontWeight(.bold)
						.frame(maxWidth: .infinity)
				}).alert(isPresented: $configError, content: {
					Alert(title: Text("Error"), message: Text("Invalid configuration, please check the entered url and token"), dismissButton: .default(Text("OK")))
				}).tint(.accentColor)
					.buttonStyle(.borderedProminent)
					.buttonBorderShape(.roundedRectangle)
					.controlSize(.large)
			}.padding()
				.navigationBarTitle("Settings")
				.navigationBarItems(trailing: Button("Cancel", role: .cancel, action: { self.presentationMode.wrappedValue.dismiss() }).foregroundColor(.red))
		}.navigationViewStyle(StackNavigationViewStyle())
	}
	
	private func validGitConfig() async -> Bool {
		var host = url
		
		if (host.contains("://")) {
			let tempUrl = URL(string: url)
			if (tempUrl != nil && tempUrl!.host != nil) {
				host = tempUrl!.host!
			} else {
				return false
			}
		}
		
		let oldUrl = API.base, oldToken = API.token
		
		API.domain = host
		API.token = token
		
		let user = await API.get(type: User.self, endpoint: "user")
		if (user != nil) {
			print(user!.name + " logged in")
			return true
		} else {
			API.base = oldUrl
			API.token = oldToken
			return false
		}
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView()
	}
}
