//
//  ConfigView.swift
//  Tanuki
//
//  Created by Felix Schindler on 11.09.25.
//

import SwiftUI

struct ConfigView: View {
	@State
	private var newHost = API.host

	@State
	private var newToken = API.token

	var body: some View {
		VStack {
			Spacer()

			Label("GitLab URL", systemImage: "link")
				.font(.headline)
			TextField("gitlab.com", text: self.$newHost)
				.textInputAutocapitalization(.never)
				.autocorrectionDisabled()

			Label("Personal Access Token", systemImage: "key")
				.padding(.top)
				.font(.headline)
			TextField("glpat-4Rzq-VKwapmWqj4MfBsi", text: self.$newToken)
				.textInputAutocapitalization(.never)
				.autocorrectionDisabled()

			VStack {
				Label("Requirements", systemImage: "checkmark.square")
					.font(.headline)
				Text("Access to the REST-API v4 and GraphQL API")
			}
			.padding(.top)

			Spacer()

			Button(
				action: {
					API.host = self.newHost
					API.token = self.newToken
					Notify.status(.success)
				},
				label: {
					Label("Save config", systemImage: "checkmark")
						.frame(maxWidth: .infinity)
				}
			)
			.tint(.accentColor)
			.buttonBorderShape(.capsule)
			.buttonStyle(.bordered)
			.controlSize(.large)
		}
		.padding()
		.textFieldStyle(.roundedBorder)
		.navigationTitle("Self-Hosted")
		.modifier(ScrollDismissIfAvailable())
	}
}

#Preview {
	NavigationView {
		ConfigView()
	}
}
