//
//  FileView.swift
//  GitLab
//
//  Created by Felix Schindler on 23.01.22.
//

import SwiftUI
import MarkdownUI

struct FileView: View {
	@State var content: String
	
	init(filePath: String, content: String) {
		let url = URL(fileURLWithPath: filePath)
		let fileType = url.pathExtension
		
		if (fileType == "md") {
			self.content = content
		} else {
			self.content = "```" + fileType + "\n" + content + "\n```"
		}
	}
	
	var body: some View {
		VStack {
			ScrollView {
				Markdown(content)
					.markdownTheme(.gitHub)
					.textSelection(.enabled)
					.frame(maxWidth: .infinity, alignment: .leading)
			}
			Spacer()
		}
	}
}

struct FileView_Previews: PreviewProvider {
	static var previews: some View {
		FileView(filePath: ".editorconfig", content: "root = true\n\n[*]\nend_of_line = lf\ninsert_final_newline = true")
	}
}
