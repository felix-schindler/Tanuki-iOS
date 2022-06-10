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
        projects = await API.get(type: [Project].self, endpoint: "projects", query: [
            "search": String(search).url(),
            "order_by": "last_activity_at"
        ])
        noConnection = projects == nil
    }
}

struct AllProjectsLoader_Previews: PreviewProvider {
    static var previews: some View {
        AllProjectsLoader()
    }
}
