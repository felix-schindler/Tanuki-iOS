//
//  NoteView.swift
//  Tanuki
//
//  Created by Felix Schindler on 27.02.24.
//

import GitLabAPI
import MarkdownUI
import SwiftUI

struct NoteView: View {
	private let note: Note

	init(_ note: Note) {
		self.note = note
	}

	private func convertIconName(_ iconName: String?) -> String {
		switch iconName {
		case "user":
			"person"
		case "comment-dots":
			"ellipsis.bubble"
		case "pencil":
			"pencil"
		case "commit":
			"circle.and.line.horizontal"
		case "check":
			"person.fill.checkmark"
		case "unapproval":
			"person.fill.xmark"
		case "timer":
			"hourglass"
		case "label":
			"tag"
		case "link":
			"link.badge.plus"
		case "unlink":
			"link"
		case "arrow-right":
			"arrowshape.turn.up.forward"
		case "clock":
			"clock"
		case "duplicate":
			"circlebadge.2"
		case "issue-close":
			"minus.circle"
		case "issues":
			"smallcircle.circle"
		case "status-health":
			"waveform.path.ecg"
		default:
			"questionmark"
		}
	}

	public var body: some View {
		if let author = note._author {
			if note.system {
				Label(
					title: {
						Markdown("@\(author.username) \(note.body)")
							.markdownTheme(.gitHub)
					},
					icon: {
						Image(
							systemName: convertIconName(note.systemNoteIconName)
						)
					}
				).font(.footnote)
			} else {
				VStack(alignment: .leading) {
					HStack {
						if let url = URL.fromAvatar(author.avatarUrl) {
							AvatarImage(url, size: .tiny)
						}
						Text(author.username)
						if let accessLevel = note.maxAccessLevelOfAuthor {
							PillView(accessLevel)
								.font(.caption2)
						}
						Spacer()
						PillView(
							Date.fromToString(
								note.createdAt, dateStyle: .short,
								timeStyle: .short),
							icon: note.updatedAt != note.createdAt
								? "pencil.and.scribble" : nil
						).font(.caption2)
					}.padding(.vertical, -5)

					Markdown(note.body, baseURL: API.url)
						.markdownTheme(.gitHub)
				}.font(.footnote)
			}
		} else {
			Label(
				title: {
					Markdown(note.body, baseURL: API.url)
						.markdownTheme(.gitHub)
				},
				icon: {
					Image(systemName: convertIconName(note.systemNoteIconName))
				}
			).font(.footnote)
		}
	}
}
