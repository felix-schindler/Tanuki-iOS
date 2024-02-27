//
//  NoteView.swift
//  Tanuki
//
//  Created by Felix Schindler on 27.02.24.
//

import SwiftUI
import GitLabAPI
import MarkdownUI

protocol NoteAuthor {
	var avatarUrl: String? { get }
	var username: String { get }
}

struct NoteAuthorStruct: NoteAuthor {
	var avatarUrl: String?
	var username: String
}

protocol Note {
	var system: Bool { get }
	var systemNoteIconName: String? { get }
	var body: String { get }
	var stupidAuthor: NoteAuthor? { get }
	var createdAt: String { get }
	var updatedAt: String { get }
	var maxAccessLevelOfAuthor: String? { get }
}

extension IssueQuery.Data.Project.Issue.Notes.Node: Note {
	var stupidAuthor: NoteAuthor? {
		guard let authorData = author else { return nil }
		return NoteAuthorStruct(avatarUrl: authorData.avatarUrl, username: authorData.username)
	}
}

extension MergeRequestQuery.Data.Project.MergeRequest.Notes.Node: Note {
	var stupidAuthor: NoteAuthor? {
		guard let authorData = author else { return nil }
		return NoteAuthorStruct(avatarUrl: authorData.avatarUrl, username: authorData.username)
	}
}

extension IssueQuery.Data.Project.Issue.Notes.Node.Author: NoteAuthor {
}
extension MergeRequestQuery.Data.Project.MergeRequest.Notes.Node.Author: NoteAuthor {
}

struct NoteView<T: Note>: View {
	private let note: T
	
	init(_ note: T) {
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
			"arrow.right"
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
		if (note.system) {
			Label(
				title: {
					let content = (note.stupidAuthor?.username != nil)
					? "@\(note.stupidAuthor?.username ?? "") \(note.body)"
					: note.body
					Markdown(content, baseURL: API.url)
				},
				icon: {
					Image(systemName: convertIconName(note.systemNoteIconName ?? ""))
				}
			).font(.footnote)
		} else if let author = note.stupidAuthor {
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
		} else {
			Markdown(note.body)
		}
	}
}
