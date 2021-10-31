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
    var description: String
    var assignees: [UserSmall]?
    var author: UserSmall
    var labels: [String]?
    var references: Reference
}

struct Reference: Decodable {
    var full: String
}

struct UserSmall: Decodable, Identifiable {
    var id: Int
    var name: String
    var username: String
}

struct IssuesView: View {
    @State var issues: [Issue]? = nil
    @State var noConnection: Bool = false
    
    var body: some View {
        VStack {
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
                List(issues!, id: \.id) { issue in
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
                    }.swipeActions {
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
                    }
                }.refreshable {
                    await getIssues()
                }
            }
        }.onAppear {
            Task.init {
                await getIssues()
            }
        }
        .navigationTitle("Issues")
    }
    
    private func closeIssue(id: Int) -> Bool {
        return false
    }
    
    private func deleteIssue(id: Int) -> Bool {
        return false
    }
    
    private func getIssues() async -> Void {
        do {
            let apiData: Data? = API.GET(endpoint: "issues?state=opened")
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

struct IssuesView_Previews: PreviewProvider {
    static var previews: some View {
        IssuesView()
    }
}
