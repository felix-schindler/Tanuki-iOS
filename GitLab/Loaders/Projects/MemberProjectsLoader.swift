//
//  ProjectsMemberView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct MemberProjectsLoader: View {
    @State var projects: [Project]? = nil
    @State var noConnection: Bool = false
    
    var body: some View {
        VStack {
            if (projects != nil) {
                ProjectListView(projects: projects!, updateFunction: getProjects)
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
            let apiData: Data? = API.GET(endpoint: "projects?membership=true")
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

struct MemberProjectsLoader_Previews: PreviewProvider {
    static var previews: some View {
        MemberProjectsLoader()
    }
}
