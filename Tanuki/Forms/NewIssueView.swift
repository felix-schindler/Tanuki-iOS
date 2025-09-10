//
//  NewIssueView.swift
//  Tanuki
//
//  Created by Felix Schindler on 10.09.25.
//

import HighlightedTextEditor
import SwiftUI

struct NewIssueView: View {
	@Environment(\.presentationMode)
	var presentationMode: Binding<PresentationMode>

	@State
	private var title = ""

	@State
	private var description = ""

	private func dismiss() {
		self.presentationMode.wrappedValue.dismiss()
	}

	private func createIssue() async {
	}

	var body: some View {
		VStack {
			Form {
				TextField("Title", text: $title)
				HighlightedTextEditor(text: $description, highlightRules: .markdown)
					.frame(minHeight: 200)
			}.scrollDismissesKeyboard(.interactively)

			Button(
				action: {
					Task {
						await createIssue()
					}
				},
				label: {
					Label("Create Issue", systemImage: "checkmark")
						.frame(maxWidth: .infinity)
				}
			)
			.buttonBorderShape(.capsule)
			.buttonStyle(.bordered)
			.controlSize(.large)
			.padding()
		}.navigationTitle("New Project")
	}
}

#Preview {
	NavigationStack {
		NewIssueView()
	}
}
