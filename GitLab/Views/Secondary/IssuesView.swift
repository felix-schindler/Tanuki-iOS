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

    @State var loading: Bool = true
    @State var noConnection: Bool = false
    
    private func deleteIssue(id: Int) -> Bool {
        return false
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
            loading = false
        } catch let jsonError as NSError {
            print("JSON error \(jsonError.localizedDescription)")
            loading = false
        }
    }

    var body: some View {
        ScrollView {
            Text("test")
            Text("test")
            if (loading) {
                Text("LOADING")
                Spacer()
                ProgressView("Loading issues...")
                Spacer()
            } else {
                Text("NOT LOADING")
                if (noConnection) {
                    Text("Failed to load issues, please try with Internet connection")
                        .foregroundColor(.red)
                } else if (issues != nil) {
                    List(issues!, id: \.id) { issue in
                        Section(header: Text(issue.title), footer: Text("Issue count: " + String(issues!.count))) {
                            Text(issue.title)
                            /* NavigationLink(destination: IssueView(issue: issue)) {
                                Text(issue.title)
                            }.swipeActions {
                                Button {
                                    if (deleteIssue(id: issue.id)) {
                                        // TODO remove issue
                                        print("Implemt delete issue")
                                    }
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(.red)
                            } */
                        }.headerProminence(.increased)
                    }.refreshable {
                        getIssues()
                    }
                } else {
                    Text("Unknown error")
                        .foregroundColor(.red)
                }
            }
        }.onAppear {
            getIssues()
        }
        .navigationTitle("Issues")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct IssuesView_Previews: PreviewProvider {
    static var previews: some View {
        IssuesView()
    }
}
