//
//  DiscussionListView.swift
//  GitLab
//
//  Created by Felix Schindler on 01.11.21.
//

import SwiftUI

struct NoteListView: View {
    @State var notes: [Note]
    
    var body: some View {
        if (!notes.isEmpty) {
            VStack {
                ForEach(notes, id: \.id) { note in
                    Text(note.author.username + " " + note.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
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
