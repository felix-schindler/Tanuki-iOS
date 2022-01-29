//
//  ExploreFeedLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct AllProjectsLoader: View {
    @State var projects: [Project]? = nil
    @State var noConnection: Bool = false

    @State var search: String = ""

    var body: some View {
        VStack {
            if (projects != nil) {
               ProjectListView(projects: projects!, updateFunction: getProjects)
                    .searchable(text: $search)
                    .onSubmit {
                        Task.init {
                            await getProjects()
                        }
                    }
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
                await getProjects()
            }
        }.navigationTitle("Projects")
    }
    
    private func getProjects() async -> Void {
        do {
            let endpoint = "projects" + (search != "" ? "?search=\(String(search).url())" : "?order_by=last_activity_at")
            let apiData: Data? = API.GET(endpoint: endpoint)
            if (apiData != nil) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                projects = try decoder.decode([Project].self, from: apiData!)
            } else {
                noConnection = true
            }
        } catch let jsonError as NSError {
            print("JSON error \(jsonError.localizedDescription)")
        }
    }
}

struct AllProjectsLoader_Previews: PreviewProvider {
    static var previews: some View {
        AllProjectsLoader()
    }
}
