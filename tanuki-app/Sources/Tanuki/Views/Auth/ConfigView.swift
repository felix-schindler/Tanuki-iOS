//
//  ConfigView.swift
//  Tanuki
//
//  Created by Felix Schindler on 11.09.25.
//

import SwiftUI

struct ConfigView: View {
	public private(set) var showSetup: Binding<Bool>

	@State var newHost = API.host

	@State var newToken = API.token

	var body: some View {
		VStack {
			Spacer()

			Label("GitLab URL", systemImage: "link")
				.font(.headline)
			TextField("gitlab.com", text: self.$newHost)
				.keyboardType(.URL)
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

				Text("Scopes")
					.font(.subheadline)
					.padding(.top, 1)
				VStack(alignment: .leading) {
					Label("`api`", systemImage: "checkmark.circle")
					Label("`read_repository`", systemImage: "checkmark.circle")
				}.font(.footnote)
			}
			.padding(.top)

			Spacer()

			AsyncButton(
				action: {
					do {
						if newHost.contains("/") {
							if let tempUrl = URL(string: newHost),
								let _newHost = tempUrl.host
							{
								newHost = _newHost
							} else {
								Notify.status(.error, "Please only provide the host, not a URI")
								return
							}
						}

						API.host = self.newHost
						API.token = self.newToken

						let user = try await API.get(
							type: RestAPIUser.self,
							endpoint: "user"
						)

						Notify.status(
							.success,
							"Welcome, \(user.username)",
							systemImage: "checkmark"
						)
						self.showSetup.wrappedValue = false
					} catch let error {
						API.host = "gitlab.com"
						API.token = ""

						Notify.status(
							.error,
							"Failed to log in",
							error.localizedDescription,
							systemImage: "xmark"
						)
					}
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
		ConfigView(showSetup: .constant(true))
	}
}
