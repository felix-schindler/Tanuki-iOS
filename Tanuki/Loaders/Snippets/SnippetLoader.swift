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
	private var snippet: SnippetQuery.Data.Snippets.Node?

	@State
	private var loadFailed = false

	@State
	private var newNoteContent = ""

	@State
	private var newNoteError = false

	init(id: String) {
		self.id = id
	}

	private func loadSnippet() {
		Network.shared.apollo.fetch(query: SnippetQuery(id: self.id)) {
			result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting namespace...")
				snippet = graphQLResult.data?.snippets?.nodes?.first ?? nil
			case .failure(let error):
				print("Failure! Error: \(error)")
				loadFailed = true
			}
		}
	}

	public var body: some View {
		List {
			if let snippet = self.snippet {
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
							.background(Color(.systemGray5))
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
					ForEach(snippet.blobs!.nodes!, id: \.self?.name) { file in
						if file != nil && file!.rawPlainData != nil {
							Section("\(file!.name ?? "File") (\(file!.size) B)") {
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
								RoundIconButton("Comment", icon: "arrow.up") {
									// TODO: Save note
									if newNoteContent.isEmpty {
										Haptics.shared.notify(.error)
										newNoteError = true
									} else {
										Haptics.shared.notify(.success)
										newNoteContent = ""
									}
								}.alert(
									"Failed to create new note",
									isPresented: $newNoteError,
									actions: {
										Button("OK") {
											newNoteError = false
										}
									})
							}
						}

						ForEach(notes, id: \.self?.id) { maybeNote in
							if let note = maybeNote {
								NoteView(note)
							}
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
						ProgressView("Loading snippet")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadSnippet()
		}.refreshable {
			loadSnippet()
		}.toolbar {
			if let snippet = self.snippet {
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
										UIPasteboard.general.string = httpUrl
									}
								}

								if let sshUrl = snippet.sshUrlToRepo {
									Button(
										"Copy SSH url",
										systemImage: "doc.on.doc"
									) {
										UIPasteboard.general.string = sshUrl
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
			}
		}.scrollDismissesKeyboard(.immediately)
	}
}

#Preview {
	NavigationStack {
		SnippetLoader(id: "gid://gitlab/PersonalSnippet/3681071")
	}
}
