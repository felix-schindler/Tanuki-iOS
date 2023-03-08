//
//  IssuesView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct IssueListView: View {
    @State var issues: [Issue]
    @State var updateFunction: () async -> Void
    
    @State var showRef: Bool = false
    @State var isError: Bool = false

    var body: some View {
        if (issues.isEmpty) {
            Text("You're all caught up, there are no issues in this project! 🚀")
        } else {
            List(issues, id: \.id) { issue in
                NavigationLink(destination: IssueView(issue: issue)) {
                    HStack {
                        if (issue.type == "INCIDENT") {
                            Image(systemName: "exclamationmark.circle")
                                .foregroundColor(.red)
                        } else {
                            Image(systemName: "smallcircle.circle")
                                .foregroundColor(.green)
                        }
                        VStack(alignment: .leading) {
                            if (issue.confidential) {
                                HStack {
                                    Text(issue.title.emojized())
                                    Image(systemName: "lock")
                                        .foregroundColor(.orange)
                                }.frame(maxWidth: .infinity, alignment: .leading)
                            } else {
                                Text(issue.title.emojized())
                            }
                            HStack {
                                HStack {
                                    Image(systemName: "text.bubble")
                                    Text(String(issue.userNotesCount))
                                }
                                HStack {
                                    Image(systemName: "clock")
                                    Text(issue.createdAt.toDateString())
                                }
                            }.frame(maxWidth: .infinity, alignment: .leading)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(issue.author.name)
                            if (showRef || UIDevice.current.userInterfaceIdiom == .pad) {
                                Text(issue.references.full)
                            } else {
                                Text(issue.references.short)
                            }
                        }.font(.caption)
                        .foregroundColor(.secondary)
                    }
                }.swipeActions {
                    Button(action: {
                        Task.init {
                            isError = await !closeIssue(id: issue.iid, projectId: issue.projectId)
                        }
                    }, label: {
                        Label("Close issue", systemImage: "checkmark.circle")
                    }).alert(isPresented: $isError, content: {
                        Alert(title: Text("Error"), message: Text("Failed to close issue"), dismissButton: .default(Text("OK")))
                    }).tint(.purple)
                }
            }.refreshable {
                await updateFunction()
            }
        }
    }
    
    // TODO: remove from array
    private func closeIssue(id: Int, projectId: Int) async -> Bool {
        let removedIssue = await API.req(type: Issue.self, method: .put, endpoint: "projects/\(projectId)/issues/\(id)?state_event=close")
        return removedIssue != nil
    }
}

struct IssueListView_Previews: PreviewProvider {
    static var previews: some View {
        IssueListView(issues: [Issue](), updateFunction: {})
    }
}
