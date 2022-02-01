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
    @State var showNewIssue: Bool = false
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "smallcircle.circle")
                    .foregroundColor(.green)
                Text(issue.references.full)
            }
            Spacer()
            HStack {
                Image(systemName: "person")
                Text(issue.author.username)
            }
        }.foregroundColor(.secondary)
            .padding(.horizontal)
        List {
            if (issue.description != "") {              // Description is "" and NOT nil when not set
                Section("Description") {
                    Markdown(issue.description.emojized())
                }
            }
            if (issue.assignees != nil && !(issue.assignees!.isEmpty)) {
                Section("Assignees") {
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
                Section("Labels") {
                    LabelListView(labels: issue.labels!)
                }
            }
            if (issue.milestone != nil) {
                Section("Milestone") {
                    Text(issue.milestone!.title.emojized())
                }
            }
            Section("Notes") {
                NotesLoader(id: issue.projectId, iid: issue.iid, type: discussionType.Issue)
            }
        }.listStyle(.grouped)
        .navigationTitle(issue.title.emojized())
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Text(issue.state.firstCapitalized)
                    .font(.footnote)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background(issue.state == "opened" ? .green : .blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                Button(action: {showNewIssue = true}) {
                    Image(systemName: "plus.circle")
                }
            }
        }.sheet(isPresented: $showNewIssue) {
            NewIssueView(id: issue.projectId)
        }
    }
}

struct IssueView_Previews: PreviewProvider {
    static var previews: some View {
        IssueView(issue: Issue(id: 0, iid: 0, projectId: 0, title: "No issue given", description: "❌", createdAt: Date(), state: "", assignees: nil, author: UserSmall(id: 0, name: "", username: "", avatarUrl: ""), type: "", userNotesCount: 0, confidential: false, references: Reference(short: "", full: "")))
    }
}
