//
//  SnippetView.swift
//  GitLab
//
//  Created by Felix Schindler on 13.06.23.
//

import SwiftUI
import MarkdownUI

struct SnippetView: View {
	@State var snippet: Snippet
	
	var body: some View {
		List {
			HStack {
				HStack(spacing: 2) {
					Image(systemName: "number.circle")
					Text(String(snippet.id))
						.textSelection(.enabled)
				}
				Spacer()
				HStack(spacing: 2) {
					VisibilityIcon(snippet.visibility)
					Text(snippet.visibility.firstCapitalized)
				}
				Spacer()
				HStack(spacing: 2) {
					Image(systemName: "clock")
					Text(snippet.createdAt.toDateString(.short))
				}
			}
			
			HStack(spacing: 2) {
				Image(systemName: "person")
				NavigationLink(snippet.author.name, destination: UserLoader(id: snippet.author.id))
			}
			
			if let description = snippet.description {
				if (!description.isEmpty) {
					Markdown(description)
						.markdownTheme(.gitHub)
				}
			}
			
			ForEach(snippet.files, id: \.rawUrl) { file in
				Section(file.path) {
					FileLoader(rawUrl: snippet.rawUrl, filePath: file.path, inline: true)
				}
			}
		}.toolbar {
			AsyncButton(systemImage: "square.and.arrow.up") {
				await URL(string: snippet.webUrl)!.share()
			}
		}.navigationTitle(snippet.title.emojized())
	}
}

struct SnippetView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			SnippetView(snippet: Snippet(
				id: 1,
				title: "Some title :smile:",
				description: nil,
				visibility: "public",
				author: UserSmall(
					id: 1,
					name: "Some name",
					username: "some_username",
					avatarUrl: "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50"
				),
				createdAt: Date(),
				updatedAt: Date(),
				projectId: nil,
				webUrl: "https://gitlab.com/snippets/1",
				rawUrl: "https://gitlab.com/snippets/1/raw",
				fileName: "some_file_name",
				files: [
					SmallFile(
						path: "some_file_name",
						rawUrl: "https://gitlab.com/snippets/1/raw"
					)
				]
			))
		}
	}
}
