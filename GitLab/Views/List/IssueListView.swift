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
            Text("There are no issues in this project🚀")
                .font(.title)
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
                            HStack {
                                Text(issue.title.emojized())
                                if (issue.confidential) {
                                    Image(systemName: "lock")
                                }
                            }.frame(maxWidth: .infinity, alignment: .leading)
                            HStack {
                                HStack {
                                    Image(systemName: "text.bubble")
                                    Text(String(issue.userNotesCount))
                                }
                                HStack {
                                    Image(systemName: "clock")
                                    Text(issue.createdAt.toDateString())
                                }
                                HStack {
                                    Text(issue.author.name)
                                }
                            }.frame(maxWidth: .infinity, alignment: .leading)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
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
                        isError = !closeIssue(id: issue.iid, projectId: issue.projectId)
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
    private func closeIssue(id: Int, projectId: Int) -> Bool {
        do {
            let apiData: Data? = API.PUT(endpoint: "projects/\(projectId)/issues/\(id)?state_event=close")
            if (apiData != nil) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                _ = try decoder.decode(Issue.self, from: apiData!)
                return true
            }
        } catch let jsonError as NSError {
            print("JSON error \(jsonError.localizedDescription)")
        }
        return false
    }
}

struct IssueListView_Previews: PreviewProvider {
    static var previews: some View {
        IssueListView(issues: [Issue](), updateFunction: {})
    }
}
