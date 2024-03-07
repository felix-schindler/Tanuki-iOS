//
//  SettingsView.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.02.24.
//

import SwiftUI

struct SettingsView: View {
	// MARK: - Config picker
	@Environment(\.dismiss)
	private var dismiss

	@State
	private var newHost = API.host

	@State
	private var newToken = API.token

	public var body: some View {
		VStack(alignment: .leading) {
			PopupHeader(
				title: "Settings",
				onClose: {
					self.dismiss()
				})
			TextField("gitlab.com", text: self.$newHost)
			TextField("Personal Access Token", text: self.$newToken)
			Spacer()
			Button(
				action: {
					API.host = self.newHost
					API.token = self.newToken
					self.dismiss()
					Haptics.shared.notify(.success)
				},
				label: {
					Label("Save new config", systemImage: "checkmark")
						.frame(maxWidth: .infinity)
				}
			)
			.tint(.green)
			.buttonStyle(.bordered)
			.controlSize(.large)
		}
		.presentationDetents([.medium])
		.scrollDismissesKeyboard(.immediately)
		.textFieldStyle(.roundedBorder)
		.padding()
	}
}

#Preview {
	NavigationStack {
	}.sheet(isPresented: .constant(true)) {
		SettingsView()
	}
}
