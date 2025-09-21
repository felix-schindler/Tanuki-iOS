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
		Form {
			TextField("Title", text: $title)

			Section("Description (Markdown supported)") {
				HighlightedTextEditor(text: $description, highlightRules: .markdown)
					.frame(minHeight: 200)
			}
		}.toolbar {
			AsyncButton("Create issue", systemImage: "checkmark") {
				await createIssue()
			}.tint(.accentColor)
		}
		.navigationTitle("New Issue")
		.modifier(ScrollDismissIfAvailable())
	}
}

#Preview {
	NavigationView {
		NewIssueView()
	}
}
