//
//  CustomEmojiLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 05.03.24.
//

import GitLabAPI
import SwiftUI

struct CustomEmojisLoader: View {
	private var fullPath: String

	@State
	private var emojis: Result<[GroupCustomEmojiQuery.Data.Group.CustomEmoji.Node?], Error>? = nil

	@State
	private var isLoading = false

	init(fullPath: String) {
		self.fullPath = fullPath
	}

	private func loadEmojis() {
		isLoading = true

		defer {
			isLoading = false
		}

		do {
			let responses = try Network.shared.apollo.fetch(
				query: GroupCustomEmojiQuery(fullPath: self.fullPath), cachePolicy: .cacheAndNetwork
			)

			Task {
				for try await response in responses {
					if let emojis = response.data?.group?.customEmoji?.nodes {
						self.emojis = .success(emojis)
						Notify.status(.success)
					} else if let errors = response.errors {
						for error in errors {
							Notify.status(.error, error.localizedDescription)
						}
					}
				}
			}
		} catch let error {
			self.emojis = .failure(error)
			Notify.status(.error)
		}
	}

	private func reloadEmojis() async {
		do {
			let repsonse = try await Network.shared.apollo.fetch(
				query: GroupCustomEmojiQuery(fullPath: self.fullPath), cachePolicy: .networkOnly)

			if let emojis = repsonse.data?.group?.customEmoji?.nodes {
				self.emojis = .success(emojis)
			}

			Notify.status(.success)
		} catch let error {
			self.emojis = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if isLoading {
				ProgressView("Loading custom emojis")
			} else if let emojis {
				switch emojis {
				case .success(let emojis):
					if emojis.isEmpty {
						ContentUnavailableView(
							"There are no custom emojis", systemImage: "face.smiling")
					} else {
						ForEach(emojis, id: \.?.id) { maybeEmoji in
							if let emoji = maybeEmoji {
								HStack {
									if let url = URL(string: emoji.url) {
										AvatarImage(url)
									}
									VStack(alignment: .leading) {
										Text(emoji.name)
										HStack(spacing: 2) {
											Image(systemName: "clock")
											Text(Date.fromToString(emoji.createdAt))
										}.font(.footnote)
									}
								}
							}
						}
					}
				case .failure(let error):
					FailedView(error.localizedDescription)
				}
			}
		}.onAppear {
			loadEmojis()
		}.refreshable {
			loadEmojis()
		}.navigationTitle("Custom Emojis")
	}
}

#Preview {
	NavigationStack {
		CustomEmojisLoader(fullPath: "gitlab-org")
	}
}
