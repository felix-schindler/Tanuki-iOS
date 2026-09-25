//
//  CodeTextView.swift
//  Tanuki
//
//  Created by Felix Schindler on 07.04.24.
//

import SwiftUI

public struct CodeTextView: View {
	private let code: String
	private let language: String
	private let fontSize: Double

	public init(
		_ code: String,
		language: String,
		fontSize: Double = 12
	) {
		self.code = code
		self.language = language
		self.fontSize = fontSize
	}

	public var body: some View {
		if language.lowercased() == "diff" {
			DiffTextView(code: code)
		} else {
			HTMLWebView(html: MarkdownHTML.codeDocument(code, language: language, fontSize: fontSize))
		}
	}
}

struct DiffTextView: View {
	let code: String

	var body: some View {
		let lines = code.components(separatedBy: "\n")
		VStack(alignment: .leading, spacing: 0) {
			ForEach(lines.indices, id: \.self) { index in
				let line = lines[index]
				Text(line.isEmpty ? " " : line)
					.font(.caption.monospaced())
					.foregroundStyle(foreground(for: line))
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.horizontal, 4)
					.background(background(for: line))
			}
		}
	}

	private enum Kind {
		case header
		case addition
		case deletion
		case hunk
		case context
	}

	private func kind(of line: String) -> Kind {
		if line.hasPrefix("+++") || line.hasPrefix("---") || line.hasPrefix("diff ") || line.hasPrefix("index ") {
			return .header
		}
		if line.hasPrefix("@@") {
			return .hunk
		}
		if line.hasPrefix("+") {
			return .addition
		}
		if line.hasPrefix("-") {
			return .deletion
		}
		return .context
	}

	private func foreground(for line: String) -> Color {
		switch kind(of: line) {
		case .addition: return .green
		case .deletion: return .red
		case .hunk: return .accentColor
		case .header: return .secondary
		case .context: return .primary
		}
	}

	private func background(for line: String) -> Color {
		switch kind(of: line) {
		case .addition: return Color.green.opacity(0.12)
		case .deletion: return Color.red.opacity(0.12)
		case .hunk: return Color.accentColor.opacity(0.08)
		case .header, .context: return .clear
		}
	}
}
