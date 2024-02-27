//
//  NoteView.swift
//  Tanuki
//
//  Created by Felix Schindler on 27.02.24.
//

import SwiftUI
import GitLabAPI
import MarkdownUI

struct NoteView: View {
	private let note: MergeRequestQuery.Data.Project.MergeRequest.Notes.Node
	
	init(_ note: MergeRequestQuery.Data.Project.MergeRequest.Notes.Node) {
		self.note = note
	}
	
	private func convertIconName(_ iconName: String) -> String {
		switch iconName {
		case "user":
			"person"
		case "comment-dots":
			"ellipsis.bubble"
		case "pencil":
			"pencil"
		case "commit":
			"circle.and.line.horizontal"
		default:
			"questionmark"
		}
	}
	
	public var body: some View {
		if (note.system) {
			Label(
				title: {
					let content = (note.author?.username != nil)
					? "@\(note.author?.username ?? "") \(note.body)"
					: note.body
					Markdown(content, baseURL: API.url)
				},
				icon: {
					Image(systemName: convertIconName(note.systemNoteIconName ?? ""))
				}
			).font(.footnote)
		} else if let author = note.author {
			VStack(alignment: .leading) {
				HStack {
					if let url = URL.fromAvatar(author.avatarUrl) {
						AvatarImage(url, size: .small)
					}
					Text(author.username)
					if let accessLevel = note.maxAccessLevelOfAuthor {
						Pill(accessLevel)
							.font(.caption2)
					}
					Spacer()
					Pill(
						Date.fromToString(note.createdAt, dateStyle: .short, timeStyle: .short),
						icon: note.updatedAt != note.createdAt ? "pencil.and.scribble" : nil
					).font(.caption2)
				}.padding(.vertical, -5)
				
				Markdown(note.body, baseURL: API.url)
			}.font(.footnote)
		}
	}
}
