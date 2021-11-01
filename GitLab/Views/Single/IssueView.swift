//
//  IssueView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI
import MarkdownUI

struct IssueView: View {
    @State var issue: Issue
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    HStack {
                        Image(systemName: "square.on.square")
                        Text(issue.references.full)
                    }
                    Spacer()
                    HStack {
                        Image(systemName: "person")
                        Text(issue.author.username)
                    }
                }.foregroundColor(.secondary)
                Text(issue.title)
                    .font(.title)
                    .padding(.top)
                if (issue.description != "") {
                    Markdown(Document(issue.description))
                       .multilineTextAlignment(.leading)
                }
            }.padding(.horizontal)
            List {
                if (issue.assignees != nil && !(issue.assignees!.isEmpty)) {
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
                if (issue.labels != nil && !(issue.labels!.isEmpty)) {
                    Section(header: Text("Labels")) {
                        ForEach(issue.labels!, id: \.self) { label in
                            Text(label)
                        }
                    }
                }
            }
        }.navigationTitle(issue.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct IssueView_Previews: PreviewProvider {
    static var previews: some View {
        IssueView(issue: Issue(id: 0, iid: 0, title: "No issue given", description: "❌", assignees: nil, author: UserSmall(id: 0, name: "", username: "", avatarUrl: ""), references: Reference(full: "lost/lost#1")))
    }
}
