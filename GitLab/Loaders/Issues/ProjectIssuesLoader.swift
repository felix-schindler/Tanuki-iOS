//
//  SingleProjectIssuesView.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct ProjectIssuesLoader: View {
    @State var id: Int
    @State var issues: [Issue]? = nil
    @State var noConnection: Bool = false
    
    var body: some View {
        VStack {
            if (issues != nil) {
                IssueListView(issues: issues!, updateFunction: getIssues)
            } else {
                if (noConnection) {
                    Text("req_failed")
                } else {
                    Spacer()
                    ProgressView("loading")
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
            let apiData: Data? = API.GET(endpoint: "projects/" + String(id) + "/issues?state=opened")
            if (apiData != nil) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                issues = try decoder.decode([Issue].self, from: apiData!)
            } else {
                noConnection = true
            }
        } catch let jsonError as NSError {
            print("JSON error \(jsonError.localizedDescription)")
        }
    }
}

struct ProjectIssuesLoader_Previews: PreviewProvider {
    static var previews: some View {
        ProjectIssuesLoader(id: Int(0))
    }
}
