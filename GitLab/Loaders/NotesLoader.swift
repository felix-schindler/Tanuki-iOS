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
                await getDiscussions()
            }
        }
    }
    
    private func getDiscussions() async -> Void {
        do {
            let apiData: Data? = API.GET(endpoint: "projects/\(id)/\(type.rawValue)/\(iid)/notes?sort=asc&order_by=updated_at")
            if (apiData != nil) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .custom(iso8601Decoder())
                notes = try decoder.decode([Note].self, from: apiData!)
            } else {
                noConnection = true
            }
        } catch let jsonError as NSError {
            print("JSON error \(jsonError.localizedDescription)")
        }
    }
}

struct NotesLoader_Previews: PreviewProvider {
    static var previews: some View {
        NotesLoader(id: 0, iid: 0, type: discussionType.Issue)
    }
}
