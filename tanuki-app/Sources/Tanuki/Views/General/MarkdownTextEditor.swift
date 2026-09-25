//
//  MarkdownTextEditor.swift
//  Tanuki
//
//  Created by Felix Schindler on 19.09.26.
//

import SwiftUI

/// A labelled, monospaced multiline editor for the app's Markdown fields.
///
/// This replaces the removed `HighlightedTextEditor`: it does not highlight as
/// you type, it only gives the forms a consistent look. `TextEditor` is
/// cross-platform in SkipUI (a Material3 `OutlinedTextField` on Android), so
/// there is no platform branch here.
struct MarkdownTextEditor: View {
	private let label: String?
	@Binding private var text: String

	/// - Parameters:
	///   - label: An optional caption shown above the editor. Leave it `nil` when
	///     the surrounding `Section` already carries the title.
	///   - text: The Markdown being edited.
	init(_ label: String? = nil, text: Binding<String>) {
		self.label = label
		self._text = text
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			if let label {
				Text(label)
					.font(.footnote)
					.foregroundStyle(.secondary)
			}

			TextEditor(text: $text)
				.font(.body.monospaced())
				.frame(minHeight: 100)
		}
	}
}
