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
                        Text(issue.title.emojized())
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(issue.author.name)
                            Text(issue.references.full)
                        }.foregroundColor(.secondary)
                        .font(.caption)
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
}

// TODO remove from array
func closeIssue(id: Int, projectId: Int) -> Bool {
    do {
        let apiData: Data? = API.PUT(endpoint: "projects/" + String(projectId) + "/issues/" + String(id) + "?state_event=close")
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

struct IssueListView_Previews: PreviewProvider {
    static var previews: some View {
        IssueListView(issues: [Issue](), updateFunction: {})
    }
}
