//
//  IssuesView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct Issue: Decodable {
    var id: Int
    var iid: Int
    var title: String
}

/* extension Issue {
    enum CodingKeys: CodingKey {
        case id
        case title
    }
} */

struct IssuesView: View {
    @State var issues: [Issue]? = nil
    @State var noConnection: Bool = false
    
    var body: some View {
        ScrollView {
            if (issues == nil) {
                if (noConnection) {
                    Text("Failed to load issues, please try with Internet connection")
                        .foregroundColor(.red)
                } else {
                    Spacer()
                    ProgressView("Loading issues...")
                    Spacer()
                }
            } else {
                List {
                    Text("test")
                    Text("test")
                    Text("test")
                }
                List(issues!, id: \.id) { issue in
                    // Section(header: Text(issue.title), footer: Text("Issue count: " + String(issues!.count))) {
                    Text(issue.title)
                    // }.headerProminence(.increased)
                }.refreshable {
                    getIssues()
                }
            }
        }.onAppear {
            getIssues()
        }
        .navigationTitle("Issues")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func getIssues() -> Void {
        do {
            let apiData: Data? = API.GET(endpoint: "issues")
            if (apiData != nil) {
                // print(String(data: apiData!, encoding: .utf8))
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

struct IssuesView_Previews: PreviewProvider {
    static var previews: some View {
        IssuesView()
    }
}
