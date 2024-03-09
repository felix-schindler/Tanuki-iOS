//
//  UserSnippetsLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.02.24.
//

import GitLabAPI
import SwiftUI

struct UserSnippetsLoader: View {
	private let username: String?

	@State
	private var snippets: [Snippet?]?

	@State
	private var loadFailed = false

	init(username: String? = nil) {
		self.username = username
	}

	private func loadSnippets() {
		if let user = username {
			Network.shared.apollo.fetch(
				query: UserSnippetsQuery(username: user)
			) {
				result in
				switch result {
				case .success(let graphQLResult):
					print("Success! Setting snippets...")
					snippets = graphQLResult.data?.user?.snippets?.nodes
				case .failure(let error):
					print("Failure! Error: \(error)")
					loadFailed = true
				}
			}
		} else {
			Network.shared.apollo.fetch(query: CurrentUserSnippetsQuery()) {
				result in
				switch result {
				case .success(let graphQLResult):
					print("Success! Setting snippets...")
					snippets = graphQLResult.data?.currentUser?.snippets?.nodes
				case .failure(let error):
					print("Failure! Error: \(error)")
					loadFailed = true
				}
			}
		}
	}

	var body: some View {
		List {
			if let snippets = self.snippets {
				if snippets.isEmpty {
					Text("There are no snippets")
				} else {
					ForEach(snippets, id: \.self?.id) { maybeSnippet in
						if let snippet = maybeSnippet {
							NavigationLink(
								destination: SnippetLoader(id: snippet.id),
								label: {
									HStack {
										VStack(alignment: .leading) {
											HStack {
												VisibilityIcon(
													snippet
														.visibilityLevel
														.rawValue
												)
												Text(snippet.title.emojized())
											}

											ScrollView(.horizontal) {
												HStack {
													if let author = snippet
														._author
													{
														AuthorView(author)
													}

													HStack(spacing: 2) {
														Image(
															systemName: "clock")
														Text(
															Date.fromToString(
																snippet
																	.createdAt))
													}
												}.font(.footnote)
											}
										}
									}.swipeActions {
										if let url = URL(string: snippet.webUrl) {
											ShareButton(url)
										}
									}
								}
							)
						}
					}
				}
			} else {
				VStack {
					Image(systemName: "scissors")
						.resizable()
						.scaledToFit()
						.frame(width: 50, height: 50)
					if loadFailed {
						Text(failedToLoad)
					} else {
						ProgressView("Loading snippets")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadSnippets()
		}.refreshable {
			loadSnippets()
		}.navigationTitle("Snippets")
	}
}

#Preview {
	NavigationStack {
		UserSnippetsLoader(username: "felix-schindler")
	}
}
