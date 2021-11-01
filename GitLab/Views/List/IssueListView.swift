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
    
    @State var showNewIssue: Bool = false

    var body: some View {
        if (issues.isEmpty) {
            Text("No issues")
        } else {
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
                }
            }.refreshable {
                await updateFunction()
            }.toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {showNewIssue = true}) {
                        Image(systemName: "plus.circle")
                    }
                }
            }.sheet(isPresented: $showNewIssue) {
                NewIssueView()
            }
        }
    }
}

struct IssueListView_Previews: PreviewProvider {
    static var previews: some View {
        IssueListView(issues: [Issue](), updateFunction: {})
    }
}
