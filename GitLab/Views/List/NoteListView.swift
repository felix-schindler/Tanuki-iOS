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
                    VStack {
                        HStack {
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
                            }.frame(width: 50, height: 50, alignment: .leading)
                            VStack {
                                Text(note.author.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(note.author.username)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        Markdown(note.body)
                            .multilineTextAlignment(.leading)
                    }
                }.listStyle(.plain)     // TODO: Does this even work??
            }
        }
    }
}

struct NoteListView_Previews: PreviewProvider {
    static var previews: some View {
        NoteListView(notes: [Note]())
    }
}
