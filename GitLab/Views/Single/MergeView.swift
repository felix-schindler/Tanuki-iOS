//
//  MergeView.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct MergeView: View {
    @State var mergeRequest: MergeRequest
    
    var body: some View {
        VStack {
            VStack {
                Text("reference")
                    .font(.headline)
                    .padding(.top)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(mergeRequest.references.full)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("author")
                    .font(.headline)
                    .padding(.top)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(mergeRequest.author.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("title")
                    .font(.headline)
                    .padding(.top)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(mergeRequest.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("description")
                    .font(.headline)
                    .padding(.top)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(mergeRequest.description)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("votes")
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
            List {
                if (mergeRequest.assignees != nil && !(mergeRequest.assignees!.isEmpty)) {
                    Section(header: Text("Assignees")) {
                        ForEach(mergeRequest.assignees!, id: \.id) { assignee in
                            HStack {
                                Text(assignee.name)
                                Spacer()
                                Text(assignee.username)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                if (mergeRequest.labels != nil && !(mergeRequest.labels!.isEmpty)) {
                    Section(header: Text("Labels")) {
                        ForEach(mergeRequest.labels!, id: \.self) { label in
                            Text(label)
                        }
                    }
                }
            }
            Spacer()
        }.navigationTitle(mergeRequest.title)
    }
}

struct MergeView_Previews: PreviewProvider {
    static var previews: some View {
        MergeView(mergeRequest: MergeRequest(id: 0, iid: 0, title: "No merge request", description: "", userNotesCount: 0, upvotes: 0, downvotes: 0, author: UserSmall(id: 0, name: "", username: ""), assignees: [UserSmall](), reviewers: [UserSmall](), labels: [""], references: Reference(full: "")))
    }
}
