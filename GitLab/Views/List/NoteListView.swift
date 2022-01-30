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
                    AsyncImage(url: URL(string: note.author.avatarUrl)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                        default:
                            Image(systemName: "exclamationmark.icloud")
                                .resizable()
                                .scaledToFit()
                        }
                    }.frame(width: 50, height: 50)
                    VStack {
                        HStack {
                            Text(note.author.name)
                            Text("\(note.author.username) · \(note.createdAt.toString())")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        Markdown(note.body.emojized())
                    }
                }
            }
        } else {
            Text("There are no notes")
        }
    }
}

struct NoteListView_Previews: PreviewProvider {
    static var previews: some View {
        NoteListView(notes: [Note]())
    }
}
