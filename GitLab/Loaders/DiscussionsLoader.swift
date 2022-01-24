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

struct DiscussionsLoader: View {
    @State var discussions: [Discussion]? = nil
    @State var noConnection: Bool = false
    
    @State var id: Int      // projectID
    @State var iid: Int     // ID of Merge, Issue or Commit
    @State var type: discussionType
    
    var body: some View {
        VStack {
            if (discussions != nil) {
                if (!discussions!.isEmpty) {
                    Text("Discussion")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ForEach(discussions!, id: \.id) { discussion in
                        NoteListView(notes: discussion.notes)
                    }
                }
            } else {
                if (noConnection) {
                    Text("Failed to load, please check your internet connection and your token")
                } else {
                    VStack {
                        Spacer()
                        ProgressView("Loading")
                        Spacer()
                    }
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
            let apiData: Data? = API.GET(endpoint: "projects/" + String(id) + "/" + type.rawValue + "/" + String(iid) + "/discussions")
            if (apiData != nil) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .custom(iso8601Decoder())
                discussions = try decoder.decode([Discussion].self, from: apiData!)
            } else {
                noConnection = true
            }
        } catch let jsonError as NSError {
            print("JSON error \(jsonError.localizedDescription)")
        }
    }
}

struct DiscussionsLoader_Previews: PreviewProvider {
    static var previews: some View {
        DiscussionsLoader(id: 0, iid: 0, type: discussionType.Issue)
    }
}
