//
//  ProjectMergeLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct ProjectMergeLoader: View {
    @State var id: Int
    @State var mergeRequests: [MergeRequest]? = nil
    @State var noConnection: Bool = false
    
    var body: some View {
        VStack {
            if (mergeRequests != nil) {
                MergeListView(mergeRequests: mergeRequests!, updateFunction: getMRs)
            } else {
                if (noConnection) {
                    Text("Failed to load, please check your internet connection and your token")
                } else {
                    VStack {
                        Spacer()
                        ProgressView("Loading")
                        Spacer()
                    }
                }
            }
        }.onAppear {
            Task.init {
                await getMRs()
            }
        }.navigationTitle("Merge requests")
    }
    
    private func getMRs() async -> Void {
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

struct ProjectMergeLoader_Previews: PreviewProvider {
    static var previews: some View {
        ProjectMergeLoader(id: Int(0))
    }
}
