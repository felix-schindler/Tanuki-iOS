//
//  NewIssue.swift
//  Tanuki
//
//  Created by Felix Schindler on 31.10.21.
//  Rewritten by Felix Schindler on 27.02.24.
//

import HighlightedTextEditor
import SwiftUI

struct CreateIssueView: View {
	@Binding
	public var showNewIssue: Bool

	@State
	private var showError = false

	@State
	private var title = ""

	@State
	private var description = ""

	public var body: some View {
		VStack(alignment: .leading) {
			PopupHeader(
				title: "New issue",
				onClose: {
					showNewIssue = false
				})

			VStack {
				TextField("Title", text: $title)
				HighlightedTextEditor(text: $description, highlightRules: .markdown)
					.border(.secondary)
			}.textFieldStyle(.roundedBorder)

			Spacer()

			VStack {
				Button(
					action: {
						if title.isEmpty {
							Notify.status(.error, "Failed to create issue")
						} else {
							Notify.status(.success)
							showNewIssue = false
						}
					},
					label: {
						Label("Create issue", systemImage: "plus")
							.frame(maxWidth: .infinity)
					}
				)
				.tint(.green)
				.controlSize(.large)
				.buttonStyle(.bordered)
			}
		}
		.padding()
		.presentationDetents([.large, .medium])
	}
}

#Preview {
	NavigationStack {
	}.sheet(isPresented: .constant(true)) {
		CreateIssueView(showNewIssue: .constant(true))
	}
}
