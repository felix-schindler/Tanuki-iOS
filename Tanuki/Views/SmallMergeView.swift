//
//  SmallMergeView.swift
//  Tanuki
//
//  Created by Felix Schindler on 28.02.24.
//

import GitLabAPI
import SwiftUI

struct SmallMergeView: View {
	private let fullPath: String
	private let mr: SmallMergeRequest

	init(_ fullPath: String, _ mr: SmallMergeRequest) {
		self.fullPath = fullPath
		self.mr = mr
	}

	var body: some View {
		NavigationLink(
			destination: MergeRequestLoader(
				fullPath: fullPath,
				iid: mr.iid
			),
			label: {
				VStack(alignment: .leading) {
					HStack(spacing: 5) {
						MergeStateIcon(mr.state)
						Text(mr.reference)
							.foregroundStyle(.secondary)
					}.font(.footnote)
					Text(mr.title.emojized())
					HStack(spacing: 10) {
						HStack(spacing: 2) {
							Image(systemName: "hand.thumbsup")
							Text(String(mr.upvotes))
						}
						HStack(spacing: 2) {
							Image(systemName: "hand.thumbsdown")
							Text(String(mr.downvotes))
						}
						HStack(spacing: 2) {
							Image(systemName: "note.text")
							Text(String(mr.userNotesCount ?? 0))
						}
						Spacer()
						ScrollView(.horizontal) {
							HStack {
								HStack(spacing: 2) {
									Image(systemName: "clock")
									Text(Date.fromToString(mr.createdAt))
								}

								if let author = mr._author {
									HStack(spacing: 2) {
										Image(systemName: "person")
										Text(author.name)
									}
								}
							}
						}
					}.font(.footnote)
				}.swipeActions {
					Button("Close", systemImage: "minus.circle") {
						// TODO: Add action
					}.tint(.blue)
					if let webUrl = URL(string: mr.webUrl ?? "") {
						ShareLink(item: webUrl) {
							Label("Share", systemImage: "square.and.arrow.up")
						}
					}
				}
			}
		)
	}
}
