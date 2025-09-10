//
//  SnippetLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.02.24.
//

import GitLabAPI
import MarkdownUI
import SwiftUI

struct SnippetLoader: View {
	private let id: String

	@State
	private var snippet: Result<SnippetQuery.Data.Snippets.Node, Error>? = nil

	@State
	private var isLoading = false

	@State
	private var newNoteContent = ""

	@State
	private var newNoteError = false

	init(id: String) {
		self.id = id
	}

	private func loadSnippet() {
		isLoading = true

		defer {
			isLoading = false
		}

		do {
			let responses = try Network.shared.apollo.fetch(
				query: SnippetQuery(id: self.id),
				cachePolicy: .cacheAndNetwork
			)

			Task {
				for try await response in responses {
					if let snippet = response.data?.snippets?.nodes?.first {
						self.snippet = .success(snippet!)
						Notify.status(.success)
					} else if let errors = response.errors {
						for error in errors {
							Notify.status(.error, error.localizedDescription)
						}
					}
				}
			}
		} catch let error {
			self.snippet = .failure(error)
			Notify.status(.error)
		}
	}

	private func reloadSnippet() async {
		do {
			let response = try await Network.shared.apollo.fetch(
				query: SnippetQuery(id: self.id),
				cachePolicy: .networkOnly
			)

			if let snippet = response.data?.snippets?.nodes?.first {
				self.snippet = .success(snippet!)
			}

			Notify.status(.success)
		} catch let error {
			self.snippet = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if isLoading {
				ProgressView("Loading snippet")
			} else if let snippet {
				switch snippet {
				case .success(let snippet):
					VStack(alignment: .leading) {
						HStack {
							Text(snippet.title.emojized())
								.font(.title3)
								.fontWeight(.medium)
								.padding(.bottom, 1)
							Spacer()
							Text(Date.fromToString(snippet.createdAt))
								.font(.footnote)
						}

						ScrollView(.horizontal) {
							HStack {
								if let author = snippet._author {
									AuthorView(author)
								}
								VisibilityIcon(
									snippet.visibilityLevel.rawValue,
									showText: true
								)
								.padding(.horizontal, 8)
								.padding(.vertical, 3)
								#if os(iOS)
									.background(Color(.systemGray5))
								#else
									.background(.accent)
								#endif
								.foregroundStyle(.primary)
								.cornerRadius(5)
							}.font(.footnote)
						}

						if let description = snippet.description {
							Markdown(description.emojized())
								.markdownTheme(.gitLab)
						}
					}

					if (snippet.blobs?.nodes?.count ?? 0) > 0 {
						ForEach(
							snippet.blobs!.nodes!,
							id: \.self?.name
						) { file in
							if file != nil && file!.rawPlainData != nil {
								Section(
									"\(file!.name ?? "File") (\(file!.size) B)"
								) {
									Markdown(
										"""
										```txt
										\(file!.rawPlainData!.trimmingCharacters(in: .whitespacesAndNewlines))
										```
										""")
								}
							}
						}
					}

					if let notes = snippet.notes.nodes {
						Section("Notes") {
							if snippet.userPermissions.createNote {
								HStack {
									TextField(
										"New note",
										text: $newNoteContent,
										axis: .vertical
									)
									RoundIconButton(
										"Comment",
										icon: "arrow.up"
									) {
										// TODO: Save note
										if newNoteContent.isEmpty {
											Notify
												.status(
													.error,
													"Please provide content"
												)
										} else {
											Notify.status(.success)
											newNoteContent = ""
										}
									}
								}
							}

							ForEach(notes, id: \.self?.id) { maybeNote in
								if let note = maybeNote {
									NoteView(note)
								}
							}
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			}
		}.onAppear {
			loadSnippet()
		}.refreshable {
			await reloadSnippet()
		}.toolbar {
			if let snippet {
				switch snippet {
				case .success(let snippet):
					Menu(
						content: {
							Section {
								if let url = URL(string: snippet.webUrl) {
									ShareButton(url)
								}
							}

							let showCloneSection =
								(snippet.httpUrlToRepo != nil
									|| snippet.sshUrlToRepo != nil)

							if showCloneSection {
								Section("Clone Code") {
									if let httpUrl = snippet.httpUrlToRepo {
										Button(
											"Copy HTTP url",
											systemImage: "doc.on.doc"
										) {
											httpUrl.copyToClipboard()
										}
									}

									if let sshUrl = snippet.sshUrlToRepo {
										Button(
											"Copy SSH url",
											systemImage: "doc.on.doc"
										) {
											sshUrl.copyToClipboard()
										}
									}
								}
							}
						},
						label: {
							Label("More", systemImage: "ellipsis")
								.frame(width: 16, height: 16)
						}
					)
					.menuStyle(.button)
					.buttonStyle(.bordered)
					.clipShape(Circle())
				case .failure:
					EmptyView()
				}
			}
		}.scrollDismissesKeyboard(.immediately)
	}
}

#Preview {
	NavigationStack {
		SnippetLoader(id: "gid://gitlab/PersonalSnippet/3681071")
	}
}
