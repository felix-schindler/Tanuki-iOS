//
//  ExploreView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct Project: Decodable {
    var id: Int
    var description: String
    var name: String
    var nameWithNamespace: String
    var httpUrlToRepo: String
    var sshUrlToRepo: String
    var forksCount: Int
    var starCount: Int
}

struct ExploreView: View {
    @State var projects: [Project]? = nil
    @State var noConnection: Bool = false
    
    var body: some View {
        NavigationView {
            if (projects == nil) {
                VStack {
                    Spacer()
                    ProgressView("Loading")
                    Spacer()
                }.navigationTitle("Explore")
            } else {
                RepositoriesView(projects: projects)
                    .navigationTitle("Explore")
            }
        }.onAppear {
            Task.init {
                await getProjects()
            }
        }
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

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
