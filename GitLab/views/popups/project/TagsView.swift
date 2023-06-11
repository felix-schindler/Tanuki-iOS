//
//  TagsView.swift
//  GitLab
//
//  Created by Felix Schindler on 05.05.23.
//

import SwiftUI
import MarkdownUI

struct TagsView: View {
	/// Project ID
	@State var id: Int
	
	@State var tags: [Tag]? = nil
	@State var loadFailed: Bool = false
	
	var body: some View {
		List {
			if (tags != nil) {
				if (tags!.isEmpty) {
					Text("You'll see your tags after you pushed them")
				} else {
					ForEach(tags!, id: \.name) { tag in
						VStack(alignment: .leading) {
							Text(tag.name.emojized())
								.fontWeight(.medium)
							
							if (!tag.message.isEmpty) {
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
				if (loadFailed) {
					Text("Failed to load, please check your internet connection and your token")
						.foregroundStyle(.red)
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
	
	private func getTags() async -> Void {
		tags = await API.get(type: [Tag].self, endpoint: "projects/\(id)/repository/tags")
		loadFailed = tags == nil
	}
}

struct TagsView_Previews: PreviewProvider {
	static var previews: some View {
		TagsView(id: 33025310)
	}
}
