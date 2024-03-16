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

	@State var tags: [Tag]? = nil
	@State var loadFailed: Bool = false

	init(_ projectId: Int) {
		self.projectId = projectId
	}

	public var body: some View {
		List {
			if tags != nil {
				if tags!.isEmpty {
					Text("You'll see your tags after you pushed them")
				} else {
					ForEach(tags!, id: \.name) { tag in
						VStack(alignment: .leading) {
							Text(tag.name.emojized())
								.fontWeight(.medium)

							if !tag.message.isEmpty {
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
			} else {
				if loadFailed {
					Text(failedToLoad)
				} else {
					ProgressView()
				}
			}
		}.onAppear {
			Task {
				await getTags()
			}
		}.refreshable {
			await getTags()
		}.navigationBarTitle("Tags")
	}

	private func getTags() async {
		tags = await API.get(type: [Tag].self, endpoint: "projects/\(projectId)/repository/tags")
		loadFailed = tags == nil
	}
}

#Preview {
	NavigationStack {
		TagsLoader(33_025_310)
	}
}
