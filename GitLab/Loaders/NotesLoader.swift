//
//  MergeDiscussionLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

enum discussionType: String {
    case Merge = "merge_requests"
    case Issue = "issues"
    case Commit = "commits"
}

struct NotesLoader: View {
    @State var notes: [Note]? = nil
    @State var noConnection: Bool = false
    
    @State var id: Int      // Project ID
    @State var iid: Int     // IID of Merge, Issue or Commit
    @State var type: discussionType
        
    var body: some View {
        VStack {
            if (notes != nil) {
                NoteListView(notes: notes!)
            } else {
                if (noConnection) {
                    Text("Failed to load, please check your internet connection and your token")
                } else {
                    ProgressView()
                }
            }
        }.onAppear {
            Task.init {
                await getNotes()
            }
        }
    }
    
    private func getNotes() async -> Void {
        notes = await API.get(type: [Note].self, endpoint: "projects/\(id)/\(type.rawValue)/\(iid)/notes", query: ["sort": "asc", "order_by": "updated_at"])
        noConnection = (notes == nil)
    }
}

struct NotesLoader_Previews: PreviewProvider {
    static var previews: some View {
        NotesLoader(id: 33025310, iid: 26, type: discussionType.Issue)
    }
}
