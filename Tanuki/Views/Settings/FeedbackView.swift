//
//  FeedbackView.swift
//  Tanuki
//
//  Created by Felix Schindler on 23.11.25.
//

import SwiftHttp
import SwiftUI

struct FeedbackView: View {
	@Environment(\.dismiss) private var dismiss

	@State
	private var email = ""

	@State
	private var desc = "\n"

	@State
	private var accepted = false

	private func submit() async {
		do {
			let url = HttpUrl(
				host: "pb.schindlerfelix.de",
				path: ["api", "collections", "tanuki_feedback", "records"]
			)
			let res = try await API.raw(
				method: .post,
				url: url,
				body: [
					"from": email,
					"text": desc,
				],
				contentType: .json,
				auth: false
			)

			if res.statusCode == .ok || res.statusCode == .created {
				Notify.status(.success, "Thank you!", "Your feedback has been submitted")
				dismiss()
			}
		} catch (let error) {
			Notify.status(.error, "Failed to submit feedback", error.localizedDescription)
		}
	}

	public var body: some View {
		VStack {
			List {
				TextField("Email address (optional)", text: $email)
					.keyboardType(.emailAddress)
					.autocorrectionDisabled()
					.textInputAutocapitalization(.never)
				VStack(alignment: .leading) {
					Text("Description")
						.foregroundStyle(.secondary)
						.font(.footnote)
					TextEditor(text: $desc)
				}
				Toggle("I have read and accept the privacy information", isOn: $accepted)
			}.toolbar {
				AsyncButton("Submit", systemImage: "checkmark") {
					await submit()
				}
				.disabled(!accepted)
				.tint(.accentColor)
			}
			
			Link("Privacy information ↗", destination: URL(string: "https://schindlerfelix.de/projects/tanuki/privacy")!)
				.padding()
		}.navigationTitle("Feedback")
	}
}

#Preview {
	NavigationView {
		FeedbackView()
	}
}
