//
//  SetupView.swift
//  Tanuki
//
//  Created by Felix Schindler on 16.03.24.
//

import MarkdownUI
import SwiftUI

struct SetupView: View {
	@State
	private var newHost = API.host

	@State
	private var newToken = API.token

	var body: some View {
		VStack {
			Spacer()

			#if os(iOS)
				if let icon = UIImage(named: "AppIcon") {
					Image(uiImage: icon)
						.resizable()
						.scaledToFit()
						.cornerRadius(15)
						.frame(maxWidth: 100, maxHeight: 100)
				}
			#endif
			Text("Welcome to **Tanuki for GitLab**")

			Spacer()

			Label("GitLab URL", systemImage: "link")
				.font(.headline)
			TextField("gitlab.com", text: self.$newHost)

			Label("Personal Access Token", systemImage: "key")
				.padding(.top)
				.font(.headline)
			TextField("glpat-4Rzq-VKwapmWqj4MfBsi", text: self.$newToken)

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
					Text("Save config")
						.frame(maxWidth: .infinity)
				}
			)
			.tint(.green)
			.buttonStyle(.bordered)
			.controlSize(.large)
		}
		.padding()
		.textFieldStyle(.roundedBorder)
		.scrollDismissesKeyboard(.immediately)
	}
}

#Preview {
	SetupView()
}
