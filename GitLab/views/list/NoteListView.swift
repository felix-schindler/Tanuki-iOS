//
//  DiscussionListView.swift
//  GitLab
//
//  Created by Felix Schindler on 01.11.21.
//

import SwiftUI
import MarkdownUI

struct NoteListView: View {
	@State var notes: [Note]
	
	var body: some View {
		if (!notes.isEmpty) {
			ForEach(notes, id: \.id) { note in
				HStack(alignment: .top) {
					if let avatarUrl = URL.fromAvatar(note.author.avatarUrl) {
						AvatarImage(url: avatarUrl, radius: 25, width: 25, height: 25)
					}
					VStack(alignment: .leading) {
						Text(note.author.name)
							.font(.callout)
							.fontWeight(.medium)
						Text(note.createdAt.toString())
							.font(.footnote)
							.foregroundColor(.secondary)
						Markdown(note.body.emojized())
					}
				}.frame(maxWidth: .infinity, alignment: .leading)
				if (note.id != notes.last!.id) {
					Divider()
				}
			}
		} else {
			Text("There are no notes")
		}
	}
}

struct NoteListView_Previews: PreviewProvider {
	static var previews: some View {
		NoteListView(notes: [
			Note(id: 1, body: "assigned to @felix-schindler", author: UserSmall(id: 3946912, name: "Felix Schindler", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"), createdAt: Date())
		])
	}
}
