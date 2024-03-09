//
//  TodoView.swift
//  Tanuki
//
//  Created by Felix Schindler on 09.03.24.
//

import GitLabAPI
import MarkdownUI
import SwiftUI

struct TodoView: View {
	private let todo: Todo

	init(_ todo: Todo) {
		self.todo = todo
	}

	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				ScrollView(.horizontal) {
					HStack {
						PillView(
							todo.state.rawValue.firstCapitalized,
							bgColor: (todo.state == .done ? .blue : .green),
							fgColor: .white
						)
						PillView(
							"\(todo.targetType.rawValue.lowercased().firstCapitalized) · \(todo.action.rawValue.replacing("_", with: " "))"
						)
					}
				}
				Spacer()
				Text(Date.fromToString(todo.createdAt))
			}.font(.footnote)

			Markdown(todo.body.emojized())
				.markdownTheme(.gitLab)

			ScrollView(.horizontal) {
				HStack {
					AuthorView(todo._author)

					if let project = todo._project {
						SmallProjectView(project, avatarSize: .tiny)
							.padding(.horizontal, 8)
							.padding(.vertical, 3)
							.background(Color(.systemGray5))
							.foregroundStyle(.primary)
							.cornerRadius(5)
					}

					if let groupPath = todo._groupPath {
						NavigationLink(
							destination: GroupLoader(fullPath: groupPath),
							label: {
								PillView(groupPath)
							})
					}
				}
			}.font(.footnote)
		}.swipeActions {
			if let webUrl = URL(string: todo._webUrl ?? "") {
				ShareButton(webUrl)
					.tint(.blue)
				Link(
					destination: webUrl,
					label: {
						Label("open in Browser", systemImage: "safari")
							.tint(.accentColor)
					})
			}
		}
	}
}
