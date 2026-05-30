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

	@State var emojis: Result<GroupCustomEmoji_Group, Error>? = nil

	init(fullPath: String) {
		self.fullPath = fullPath
	}

	private func loadEmojis() {
		Task {
			do {
				let payload = try await Network.shared.service.fetchGroupCustomEmoji(fullPath: self.fullPath)
				self.emojis = .success(payload)
			} catch let error {
				self.emojis = .failure(error)
				Notify.status(.error)
			}
		}
	}

	private func reloadEmojis() async {
		do {
			let payload = try await Network.shared.service.fetchGroupCustomEmoji(fullPath: self.fullPath, strategy: .networkOnly)
			self.emojis = .success(payload)
			Notify.status(.success)
		} catch let error {
			self.emojis = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if let emojis {
				switch emojis {
				case .success(let payload):
					let nodes = payload.customEmoji?.nodes ?? []
					if nodes.isEmpty {
						NoContentView(
							"There are no custom emojis", systemImage: "face.smiling")
					} else {
						ForEach(nodes, id: \.id) { emoji in
							HStack {
								if let url = URL(string: emoji.url ?? "") {
									AvatarImage(url)
								}
								VStack(alignment: .leading) {
									if let name = emoji.name {
										Text(name)
									}
									if let createdAt = emoji.createdAt {
										HStack(spacing: 2) {
											Image(systemName: "clock")
											Text(Date.fromToString(createdAt))
										}.font(.footnote)
									}
								}
							}
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading custom emojis", systemImage: "face.smiling")
			}
		}.onAppear {
			loadEmojis()
		}.refreshable {
			await reloadEmojis()
		}.navigationTitle("Custom Emojis")
	}
}

#Preview {
	NavigationView {
		CustomEmojisLoader(fullPath: "gitlab-org")
	}
}
