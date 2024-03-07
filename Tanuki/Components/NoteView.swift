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
						Markdown(
							"@\(author.username) \(note.body)", baseURL: API.url
						)
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
						ScrollView(.horizontal) {
							AuthorView(author, showUsername: true)
						}

						if let accessLevel = note.maxAccessLevelOfAuthor {
							PillView(accessLevel)
						}

						Spacer()

						HStack {
							if note.updatedAt != note.createdAt {
								Image("pencil.and.scribble")
							}
							Text(
								Date.fromToString(
									note.createdAt,
									dateStyle: .short,
									timeStyle: .short
								)
							)
						}.foregroundStyle(.secondary)
					}
					.padding(.vertical, -5)
					.font(.footnote)

					Markdown(note.body, baseURL: API.url)
						.markdownTheme(.gitHub)
				}
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
