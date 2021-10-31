//
//  AllMergeLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct AllMergeLoader: View {
    @State var mergeRequests: [MergeRequest]? = nil
    @State var noConnection: Bool = false
    
    var body: some View {
        NavigationView {
            if (mergeRequests != nil) {
                MergeListView(mergeRequests: mergeRequests!, updateFunction: getMRs)
            } else {
                if (noConnection) {
                    Text("req_failed")
                } else {
                    VStack {
                        Spacer()
                        ProgressView("loading")
                        Spacer()
                    }
                }
            }
        }.onAppear {
            Task.init {
                await getMRs()
            }
        }
        .navigationTitle("Merge requests")
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

struct AllMergeLoader_Previews: PreviewProvider {
    static var previews: some View {
        AllMergeLoader()
    }
}
