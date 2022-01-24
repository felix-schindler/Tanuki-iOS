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
        do {
            let apiData: Data? = API.GET(endpoint: "issues?state=opened&with_labels_details=true")
            if (apiData != nil) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .custom(iso8601Decoder())
                issues = try decoder.decode([Issue].self, from: apiData!)
            } else {
                noConnection = true
            }
        } catch let jsonError as NSError {
            print("JSON error \(jsonError.localizedDescription)")
        }
    }
}

struct AllIssuesLoader_Previews: PreviewProvider {
    static var previews: some View {
        AllIssuesLoader()
    }
}
