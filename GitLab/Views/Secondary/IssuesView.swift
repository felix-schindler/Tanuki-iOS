//
//  IssuesView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct Issue: Decodable {
    var id: Int
    var title: String
}

struct IssuesView: View {
    @State var issues: [Issue]? = nil

    @State var loading: Bool = false
    @State var noConnection: Bool = false
    
    private func deleteIssue(id: Int) -> Bool {
        return false
    }
    
    private func getIssues() -> Void {
        loading = true
        do {
            let apiData: Data? = API.GET(endpoint: "issues")
            if (apiData != nil) {
                let decoder = JSONDecoder()
                issues = try decoder.decode([Issue].self, from: apiData!)
            } else {
                noConnection = true
            }
            loading = false
        } catch {
            print("JSON error!")
            loading = false
        }
    }

    var body: some View {
        ScrollView {
            if (issues != nil) {
                List(issues!, id: \.id) { issue in
                    NavigationLink(destination: IssueView(issue: issue)) {
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
                    }
                }.refreshable {
                    getIssues()
                }
            } else {
                if (loading) {
                    
                } else {
                    if (noConnection) {
                        Text("Failed to load issues, please try with Internet connection")
                            .foregroundColor(.red)
                    } else {
                        ProgressView()
                    }
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
