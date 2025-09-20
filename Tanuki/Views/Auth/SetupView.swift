//
//  SetupView.swift
//  Tanuki
//
//  Created by Felix Schindler on 16.03.24.
//

import MarkdownUI
import SwiftUI

struct SetupView: View {
	var body: some View {
		NavigationStack {
			VStack {
				Spacer()

				if let icon = UIImage(named: "AppIcon") {
					Image(uiImage: icon)
						.resizable()
						.scaledToFit()
						.cornerRadius(15)
						.frame(maxWidth: 100, maxHeight: 100)
				}
				Text("Welcome to **Tanuki for GitLab**")

				Spacer()

				Button(
					action: {
					},
					label: {
						Label("Login with GitLab.com", systemImage: "")
							.frame(maxWidth: .infinity)
					}
				)
				.tint(.accentColor)
				.buttonBorderShape(.capsule)
				.buttonStyle(.borderedProminent)
				.controlSize(.large)

				NavigationLink(
					destination: ConfigView(),
					label: {
						Label("Self-Hosted instance", systemImage: "")
							.frame(maxWidth: .infinity)
					}
				)
				.tint(.accentColor)
				.buttonBorderShape(.capsule)
				.buttonStyle(.bordered)
				.controlSize(.large)

				Spacer()
			}
			.padding()
			.textFieldStyle(.roundedBorder)
			.scrollDismissesKeyboard(.immediately)
		}
	}
}

#Preview {
	SetupView()
}
