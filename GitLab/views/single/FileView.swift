//
//  FileView.swift
//  GitLab
//
//  Created by Felix Schindler on 23.01.22.
//

import SwiftUI
import MarkdownUI
import Splash

struct FileView: View {
	@Environment(\.colorScheme) private var colorScheme
	private var content: String
	
	init(filePath: String, content: String) {
		let url = URL(fileURLWithPath: filePath)
		let fileType = url.pathExtension
		
		if (fileType != "md") {
			self.content = "```\(fileType)\n\(content)\n```"
		} else {
			self.content = content
		}
	}
	
	var body: some View {
		VStack {
			ScrollView {
				Markdown(content)
					.markdownCodeSyntaxHighlighter(.splash(theme: self.theme))
					.textSelection(.enabled)
					.frame(maxWidth: .infinity, alignment: .leading)
			}
			Spacer()
		}
	}
	
	private var theme: Splash.Theme {
		// NOTE: We are ignoring the Splash theme font
		switch self.colorScheme {
		case .dark:
			return .wwdc17(withFont: .init(size: 16))
		default:
			return .presentation(withFont: .init(size: 16))
		}
	}
}

#Preview {
	FileView(
		filePath: ".editorconfig",
		content: "root = true\n\n[*]\nend_of_line = lf\ninsert_final_newline = true"
	)
}
