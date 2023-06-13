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
			VStack(alignment: .leading) {
				HStack {
					HStack(spacing: 2) {
						Image(systemName: "number.circle")
						Text(String(snippet.id))
							.textSelection(.enabled)
					}
					HStack(spacing: 2) {
						Image(systemName: "person")
						NavigationLink(snippet.author.name, destination: UserLoader(id: snippet.author.id))
					}
					HStack(spacing: 2) {
						VisibilityIcon(snippet.visibility)
						Text(snippet.visibility.firstCapitalized)
					}
				}
				
				Text(snippet.createdAt.toString())
					.font(.footnote)
			}
			
			if (!(snippet.description?.isEmpty ?? false)) {
				Markdown(snippet.description!)
					.markdownTheme(.gitHub)
			}
			
			ForEach(snippet.files, id: \.rawUrl) { file in
				FileLoader(rawUrl: snippet.rawUrl, inline: true)
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
