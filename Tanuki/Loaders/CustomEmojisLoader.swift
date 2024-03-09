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
	private var emojis: [GroupCustomEmojiQuery.Data.Group.CustomEmoji.Node?]? = nil

	@State
	private var loadFailed = false

	init(fullPath: String) {
		self.fullPath = fullPath
	}

	private func loadEmojis() {
		Network.shared.apollo.fetch(query: GroupCustomEmojiQuery(fullPath: self.fullPath)) {
			result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting releases...")
				emojis = graphQLResult.data?.group?.customEmoji?.nodes
			case .failure(let error):
				print("Failure! Error: \(error)")
				loadFailed = true
			}
		}
	}

	var body: some View {
		List {
			if let emojis = self.emojis {
				if emojis.isEmpty {
					Text("There are no custom emojis")
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
			} else {
				VStack {
					if loadFailed {
						Text(failedToLoad)
					} else {
						ProgressView("Loading custom emojis")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
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
