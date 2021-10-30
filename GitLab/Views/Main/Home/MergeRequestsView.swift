//
//  MergeRequestsView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct MergeRequest: Decodable {
    var id: Int
    var iid: Int
    var title: String
    var description: String
    var userNotesCount: Int
    var upvotes: Int
    var downvotes: Int
    var author: User
    var assignees: [User]
    var reviewers: [User]
    var labels: [String]?
    var references: Reference
}

struct MergeRequestsView: View {
    @State var mergeRequests: [MergeRequest]? = nil
    @State var noConnection: Bool = false
    
    var body: some View {
        VStack {
            if (mergeRequests != nil) {
                List(mergeRequests!, id: \.id) { mr in
                    HStack {
                        Text(mr.title)
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(mr.author.name)
                            Text(mr.references.full)
                        }.foregroundColor(.secondary)
                        .font(.caption)
                    } /* TODO .swipeActions {
                        left to right hand.thumbsup
                        right to left hand.thumbsdown
                    } */
                }.refreshable {
                    await getMRs()
                }
            } else {
                if (noConnection) {
                    Text("No internet connection, please try again later.")
                        .foregroundColor(.red)
                } else {
                    Spacer()
                    ProgressView("Loading")
                    Spacer()
                }
            }
        }.onAppear {
            Task.init {
                await getMRs()
            }
        }.navigationBarTitle("Merge Requests")
    }
    
    private func getMRs() async -> Void {
        do {
            let apiData: Data? = API.GET(endpoint: "merge_requests?state=opened")
            if (apiData != nil) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                mergeRequests = try decoder.decode([MergeRequest].self, from: apiData!)
            } else {
                noConnection = true
            }
        } catch let jsonError as NSError {
            print("JSON error \(jsonError.localizedDescription)")
        }
    }
}

struct MergeRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        MergeRequestsView()
    }
}
