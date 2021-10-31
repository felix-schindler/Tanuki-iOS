//
//  SingleProjectIssuesView.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct ProjectIssuesLoader: View {
    @State var id: Int
    @State var mergeRequests: [MergeRequest]? = nil
    @State var noConnection: Bool = false
    
    var body: some View {
        VStack {
            if (mergeRequests != nil) {
                MergeListView(mergeRequests: mergeRequests!, updateFunction: getMRs)
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
        
    private func getIssues() async -> Void {
        do {
            let apiData: Data? = API.GET(endpoint: "projects/" + String(id) + "/merge_requests")
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

struct ProjectIssuesLoader_Previews: PreviewProvider {
    static var previews: some View {
        ProjectIssuesLoader(id: Int(0))
    }
}
