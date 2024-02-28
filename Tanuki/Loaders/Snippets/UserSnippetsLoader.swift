//
//  UserSnippetsLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.02.24.
//

import GitLabAPI
import SwiftUI

struct UserSnippetsLoader: View {
	@State
	private var snippets: [UserSnippetsQuery.Data.CurrentUser.Snippets.Node?]?

	@State
	private var loadFailed = false

	private func loadSnippets() {
		Network.shared.apollo.fetch(query: UserSnippetsQuery()) { result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting namespace...")
				snippets = graphQLResult.data?.currentUser?.snippets?.nodes
			case .failure(let error):
				print("Failure! Error: \(error)")
				loadFailed = true
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
										if let url = URL.fromAvatar(
											snippet.author?.avatarUrl)
										{
											AvatarImage(url, size: .medium)
										}

										VStack(alignment: .leading) {
											Text(snippet.title.emojized())

											HStack {
												if let author = snippet.author {
													HStack(spacing: 2) {
														Image(
															systemName: "person"
														)
														Text(author.name)
													}
												}

												HStack(spacing: 2) {
													Image(systemName: "clock")
													Text(
														Date.fromToString(
															snippet.createdAt))
												}
											}.font(.footnote)
										}
									}.swipeActions {
										if let url = URL(string: snippet.webUrl)
										{
											ShareButton(url)
										}
									}
								}
							)
						}
					}
				}
			} else {
				VStack(alignment: .center) {
					Image(systemName: "scissors")
						.resizable()
						.scaledToFit()
						.frame(width: 50, height: 50)
					if loadFailed {
						Text(LOAD_FAILED)
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
		UserSnippetsLoader()
	}
}
