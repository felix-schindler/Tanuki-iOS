//
//  TagsView.swift
//  GitLab
//
//  Created by Felix Schindler on 05.05.23.
//

import MarkdownUI
import SwiftUI

struct Tag: Codable {
	let name: String
	let message: String  // Empty string if not set
	let target: String
	let commit: Commit
	let protected: Bool
}

struct TagsLoader: View {
	private let projectId: Int

	@State
	private var tags: Result<[Tag], Error>? = nil

	@State
	private var isLoading = false

	init(_ projectId: Int) {
		self.projectId = projectId
	}

	private func loadTags() async {
		isLoading = true

		defer {
			isLoading = false
		}

		do {
			let temp = try await API.get(
				type: [Tag].self,
				endpoint: "projects/\(projectId)/repository/tags"
			)

			self.tags = .success(temp)
			Notify.status(.success)
		} catch let error {
			self.tags = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if isLoading {
				ProgressView("Loading Tags")
			} else if let tags {
				switch tags {
				case .success(let tags):
					if tags.isEmpty {
						ContentUnavailableView(
							"You'll see your tags after you pushed them",
							systemImage: "chevron.left.forwardslash.chevron.right")
					} else {
						ForEach(tags, id: \.name) { tag in
							VStack(alignment: .leading) {
								Text(tag.name.emojized())
									.fontWeight(.medium)

								if tag.message.isNotEmpty {
									Markdown(tag.message)
								}

								VStack(alignment: .leading) {
									HStack(alignment: .top) {
										Text(tag.commit.shortId)
											.font(.system(.footnote, design: .monospaced))
										Text(tag.commit.authoredDate.toString())
									}
									Text(tag.commit.title.emojized())
								}.font(.footnote)
							}
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			}
		}.onAppear {
			Task {
				await loadTags()
			}
		}.refreshable {
			await loadTags()
		}.navigationTitle("Tags")
	}
}

#Preview {
	NavigationStack {
		TagsLoader(33_025_310)
	}
}
