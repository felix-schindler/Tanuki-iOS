//
//  SnippetsLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 11.06.23.
//

import SwiftUI

struct SnippetsLoader: View {
	@State private var snippets: [Snippet]? = nil
	@State private var loadFailed = false
	
	@State var `public`: Bool = false
	
	var body: some View {
		List {
			if let snippets = self.snippets {
				if (snippets.isEmpty)  {
					Text("There are no snippets")
				} else {
					ForEach(snippets, id: \.id) { snippet in
						HStack {
							if let avatarUrl = URL.fromAvatar(snippet.author.avatarUrl) {
								AvatarImage(url: avatarUrl, radius: 7.5, width: 30, height: 30)
							}
							VStack(alignment: .leading) {
								Text(snippet.title)
									.fontWeight(.medium)
								HStack {
									HStack(spacing: 2) {
										Image(systemName: "person")
										Text(snippet.author.name)
									}

									HStack(spacing: 2) {
										Image(systemName: "clock")
										Text(snippet.createdAt.toDateString())
									}
								}.font(.footnote)
							}
						}
					}
				}
			} else if (self.loadFailed) {
				Label("Failed to load, please check your internet connection and your token", systemImage: "exclamationmark.octagon.fill")
					.foregroundStyle(.red)
			} else {
				ProgressView()
			}
		}.onAppear {
			Task {
				await loadSnippets()
			}
		}.refreshable {
			await loadSnippets()
		}.navigationTitle("Snippets")
	}
	
	private func loadSnippets() async -> Void {
		var endpoint = "snippets"
		if (self.public) {
			endpoint.append("/public")
		}

		snippets = await API.get(type: [Snippet].self, endpoint: endpoint)
		if (snippets == nil) {
			loadFailed = true
		}
	}
}

struct SnippetsLoader_Previews: PreviewProvider {
	static var previews: some View {
		SnippetsLoader()
	}
}
