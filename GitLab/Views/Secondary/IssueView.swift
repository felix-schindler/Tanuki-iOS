//
//  IssueView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct IssueView: View {
    @State var issue: Issue
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                // Meta data
                Text("Meta")
                    .font(.headline)
                Text("Ref: " + issue.references.full)
                Text("Author: " + issue.author.name)

                // Description
                Text("Description")
                    .font(.headline)
                    .padding(.top)
                if (issue.description != "") {
                    Text(issue.description)
                } else {
                    Text("No description available")
                }
            }.padding()
            List {
                if (issue.assignees != nil) {
                    Section(header: Text("Assignees")) {
                        ForEach(issue.assignees!, id: \.id) { assignee in
                            HStack {
                                Text(assignee.name)
                                Spacer()
                                Text(assignee.username)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                if (issue.labels != nil) {
                    Section(header: Text("Labels")) {
                        ForEach(issue.labels!, id: \.self) { label in
                            Text(label)
                        }
                    }
                }
            }
            Spacer()
        }.navigationTitle(issue.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct IssueView_Previews: PreviewProvider {
    static var previews: some View {
        IssueView(issue: Issue(id: 0, iid: 0, title: "No issue given", description: "❌", assignees: nil, author: User(id: 0, name: "", username: ""), references: Reference(full: "lost/lost#1")))
    }
}
