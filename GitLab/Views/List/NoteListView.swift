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
            VStack {
                ForEach(notes, id: \.id) { note in
                    Markdown(Document(note.author.username + " " + note.body))
                        .multilineTextAlignment(.leading)
                }
            }
        }
    }
}

struct NoteListView_Previews: PreviewProvider {
    static var previews: some View {
        NoteListView(notes: [Note]())
    }
}
