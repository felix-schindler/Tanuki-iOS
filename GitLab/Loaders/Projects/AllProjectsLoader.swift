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
    
    var body: some View {
        NavigationView {
            if (projects != nil) {
                ProjectListView(projects: projects!, updateFunction: getProjects)
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
                await getProjects()
            }
        }.navigationTitle("Explore")
    }
    
    private func getProjects() async -> Void {
        do {
            let apiData: Data? = API.GET(endpoint: "projects?order_by=last_activity_at")
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
