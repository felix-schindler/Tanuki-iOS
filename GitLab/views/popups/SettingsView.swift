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
		NavigationStack {
			VStack {
				Label("GitLab URL", systemImage: "link")
					.font(.headline)
				TextField("https://gitlab.com", text: $url)
					.textFieldStyle(.roundedBorder)
					.textContentType(.URL)
					.keyboardType(.URL)
				Label("Personal Access Token", systemImage: "key")
					.font(.headline)
					.padding(.top)
				TextField("glpat-4Rzq-VKwapmWqj4MfBsi", text: $token)
					.textFieldStyle(.roundedBorder)
					.disableAutocorrection(true)
				VStack {
					Text("Requirements")
						.fontWeight(.medium)
					
					VStack(alignment: .leading) {
						HStack(spacing: 2) {
							Image(systemName: "checkmark.square")
							Text("api")
						}
						HStack(spacing: 2) {
							Image(systemName: "checkmark.square")
							Text("read_user")
						}
						HStack(spacing: 2) {
							Image(systemName: "checkmark.square")
							Text("read_api")
						}
						HStack(spacing: 2) {
							Image(systemName: "checkmark.square")
							Text("read_repository")
						}
					}
					Text("The required API version is v4")
				}.padding()
					.font(.footnote)
					.foregroundStyle(.secondary)
				
				AsyncButton(action: {
					configError = await !validGitConfig()
					if (!configError) {
						self.presentationMode.wrappedValue.dismiss()
					}
				}, label: {
					Label("Save configuration", systemImage: "checkmark.circle")
				}).tint(.green)
					.buttonStyle(.bordered)
					.controlSize(.large)
			}.toolbar {
				RoundIconButton("Cancel", icon: "xmark", role: .cancel) {
					if (API.domain.isEmpty || API.token.isEmpty) {
						configError = true
					} else {
						self.presentationMode.wrappedValue.dismiss()
					}
				}.tint(.secondary)
			}.alert(isPresented: $configError) {
				Alert(title: Text("Error"), message: Text("Invalid configuration, please check the entered url and token"), dismissButton: .default(Text("OK")))
			}
			.padding()
			.navigationBarTitle("Settings")
		}
	}
	
	private func validGitConfig() async -> Bool {
		var host = url
		
		// If the entered URL contains
		// anything else other than the
		// host (e.g. protocol or path)
		// then strip it
		if (host.contains("/")) {
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
			print("Failed to login, resetting url and token")
			API.base = oldUrl
			API.token = oldToken
			return false
		}
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		@State var presented = true
		NavigationStack {
		}.sheet(isPresented: $presented) {
			SettingsView()
		}
	}
}
