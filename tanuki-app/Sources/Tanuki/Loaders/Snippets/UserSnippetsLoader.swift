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

	@State var snippets: Result<[Snippet], Error>? = nil

	init(username: String? = nil) {
		self.username = username
	}

	private func loadSnippets() {
		Task {
			do {
				if let username {
					let snippets = try await Network.shared.service.fetchUserSnippets(username: username)
					self.snippets = .success(snippets)
				} else {
					let snippets = try await Network.shared.service.fetchCurrentUserSnippets()
					self.snippets = .success(snippets)
				}
			} catch let error {
				self.snippets = .failure(error)
				Notify.status(.error)
			}
		}
	}

	private func reloadSnippets() async {
		do {
			if let username {
				let snippets = try await Network.shared.service.fetchUserSnippets(username: username)
				self.snippets = .success(snippets)
			} else {
				let snippets = try await Network.shared.service.fetchCurrentUserSnippets()
				self.snippets = .success(snippets)
			}

			Notify.status(.success)
		} catch let error {
			self.snippets = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if let snippets {
				switch snippets {
				case .success(let snippets):
					if snippets.isEmpty {
						NoContentView("There are no snippets", systemImage: "scissors")
					} else {
						ForEach(snippets, id: \.id) { snippet in
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
										ShareButton(URL(string: snippet.webUrl)!)
									}
								}
							)
						}
					}
				case .failure(let error):
					FailedView(error.localizedDescription, icon: "scissors")
				}
			} else {
				LoadingView("Loading Snippets", systemImage: "scissors")
			}
		}.onAppear {
			loadSnippets()
		}.refreshable {
			await reloadSnippets()
		}.navigationTitle("Snippets")
	}
}

#Preview {
	NavigationView {
		UserSnippetsLoader(username: "felix-schindler")
	}
}
