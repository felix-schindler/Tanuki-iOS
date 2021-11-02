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
                Text(issue.title.emojized())
                    .font(.title)
                    .padding(.top)
                if (issue.description != "") {
                    Markdown(Document(issue.description.emojized()))
                       .multilineTextAlignment(.leading)
                }
            }.padding(.horizontal)
            if (issue.assignees != nil && !(issue.assignees!.isEmpty)) {
                VStack {
                    Text("Assignees")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ForEach(issue.assignees!, id: \.id) { assignee in
                        HStack {
                            Text(assignee.name)
                            Spacer()
                            Text(assignee.username)
                                .foregroundColor(.secondary)
                        }
                    }
                }.padding()
            }
            if (issue.labels != nil && !(issue.labels!.isEmpty)) {
                VStack {
                    Text("Labels")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ForEach(issue.labels!, id: \.self) { label in
                        Text(label)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }.padding()
            }
            DiscussionsLoader(id: issue.projectId, iid: issue.iid, type: discussionType.Issue)
        }.navigationTitle(issue.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct IssueView_Previews: PreviewProvider {
    static var previews: some View {
        IssueView(issue: Issue(id: 0, iid: 0, projectId: 0, title: "No issue given", description: "❌", assignees: nil, author: UserSmall(id: 0, name: "", username: "", avatarUrl: ""), references: Reference(full: "lost/lost#1")))
    }
}
