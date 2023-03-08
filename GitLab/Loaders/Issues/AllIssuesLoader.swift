//
//  AllProjectsIssueLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct AllIssuesLoader: View {
    @State var issues: [Issue]? = nil
    @State var noConnection: Bool = false
    
    var body: some View {
        VStack {
            if (issues != nil) {
                IssueListView(issues: issues!, updateFunction: getIssues, showRef: true)
            } else {
                if (noConnection) {
                    Text("Failed to load, please check your internet connection and your token")
                } else {
                    Spacer()
                    ProgressView("Loading")
                    Spacer()
                }
            }
        }.onAppear {
            Task.init {
                await getIssues()
            }
        }.navigationTitle("Issues")
    }
    
    private func getIssues() async -> Void {
        issues = await API.get(type: [Issue].self, endpoint: "issues", query: ["state": "opened", "with_labels_details": "true", "order_by": "updated_at"])
        noConnection = (issues == nil)
    }
}

struct AllIssuesLoader_Previews: PreviewProvider {
    static var previews: some View {
        AllIssuesLoader()
    }
}
