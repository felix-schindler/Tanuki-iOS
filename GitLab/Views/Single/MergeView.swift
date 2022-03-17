//
//  MergeView.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI
// import MarkdownUI

struct MergeView: View {
    @State var mergeRequest: MergeRequest
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    HStack {
                        Image(systemName: "arrow.triangle.pull")
                            .foregroundColor(.blue)
                        Text(mergeRequest.references.full)
                    }
                    Spacer()
                    HStack {
                        Image(systemName: "person")
                        Text(mergeRequest.author.username)
                    }
                }.foregroundColor(.secondary)
                Text(mergeRequest.title)
                    .font(.title)
                    .padding(.top)
                // Markdown(mergeRequest.description)
                Text(mergeRequest.description)
                Text("Votes")
                    .font(.headline)
                    .padding(.top)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    HStack {
                        Image(systemName: "hand.thumbsup")
                        Text(String(mergeRequest.upvotes))
                    }
                    HStack {
                        Image(systemName: "hand.thumbsdown")
                        Text(String(mergeRequest.downvotes))
                    }
                    Spacer()
                }
            }.padding(.horizontal)
            if (mergeRequest.assignees != nil && !(mergeRequest.assignees!.isEmpty)) {
                VStack {
                    Text("Assignees")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ForEach(mergeRequest.assignees!, id: \.id) { assignee in
                        HStack {
                            Text(assignee.name)
                            Spacer()
                            Text(assignee.username)
                                .foregroundColor(.secondary)
                        }
                    }
                }.padding()
            }
            if (mergeRequest.labels != nil && !(mergeRequest.labels!.isEmpty)) {
                LabelListView(labels: mergeRequest.labels!)
                    .padding()
            }
            NotesLoader(id: mergeRequest.projectId, iid: mergeRequest.iid, type: discussionType.Merge)
        }.navigationTitle(mergeRequest.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MergeView_Previews: PreviewProvider {
    static var previews: some View {
        MergeView(mergeRequest: MergeRequest(id: 0, iid: 0, projectId: 0, title: "No merge request", description: "", userNotesCount: 0, upvotes: 0, downvotes: 0, author: UserSmall(id: 0, name: "", username: "", avatarUrl: ""), assignees: [UserSmall](), reviewers: [UserSmall](), labels: [APILabel](), references: Reference(short: "", full: "")))
    }
}
