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
        List {
            Section("Issue") {
                VStack(alignment: .leading) {
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
                    HStack {
                        Text(issue.state.firstCapitalized)
                            .padding(5)
                            .background(issue.state == "opened" ? .green : .blue)
                                .foregroundColor(.white)
                            .cornerRadius(10)
                        Text(issue.title.emojized())
                            .font(.title)
                    }.padding(.top)
                    if (issue.description != "") {
                        Markdown(issue.description.emojized())
                    }
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
        .navigationTitle(issue.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
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
