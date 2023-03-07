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
                        .frame(maxWidth: .infinity, alignment: .leading)
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
        IssueView(issue: Issue(id: 119029091, iid: 21, projectId: 33025310, title: "View Pipeline in Live Activities", description: "Should be shown of the latest project (with repository) in the latest branch that was viewed", createdAt: Date(), state: "opened", labels: [], milestone: nil, assignees: nil, author: UserSmall(id: 9005085, name: "Felix", username: "felix-schindler", avatarUrl: "https://gitlab.com/uploads/-/system/user/avatar/9005085/avatar.png"), type: "ISSUE", userNotesCount: 0, confidential: false, references: Reference(short: "#21", full: "felix-schindler/gitlab-ios#21")))
    }
}
