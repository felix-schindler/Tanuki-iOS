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
    
    var body: some View {
        List(issues, id: \.id) { issue in
            NavigationLink(destination: IssueView(issue: issue)) {
                HStack {
                    Text(issue.title)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(issue.author.name)
                        Text(issue.references.full)
                    }.foregroundColor(.secondary)
                    .font(.caption)
                }
            }/* .swipeActions {
                Button {
                    if (closeIssue(id: issue.id)) {
                        print("Implement close issue")
                    }
                } label: {
                    Image(systemName: "checkmark.circle")
                }.tint(.green)
                Button {
                    if (deleteIssue(id: issue.id)) {
                        // TODO remove issue
                        print("Implement delete issue")
                    }
                } label: {
                    Image(systemName: "trash")
                }.tint(.red)
            } */
        }.refreshable {
            await updateFunction()
        }
    }
    
    /* UNUSED private func closeIssue(id: Int) -> Bool {
        return false
    }
    
    private func deleteIssue(id: Int) -> Bool {
        return false
    } */
}

struct IssueListView_Previews: PreviewProvider {
    static var previews: some View {
        IssueListView(issues: [Issue](), updateFunction: {})
    }
}
