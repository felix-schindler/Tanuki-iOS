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
            }
        }.refreshable {
            await updateFunction()
        }
    }
}

struct IssueListView_Previews: PreviewProvider {
    static var previews: some View {
        IssueListView(issues: [Issue](), updateFunction: {})
    }
}
