//
//  ProjectsMemberView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct MemberReposView: View {
    @State var projects: [Project]? = nil
    @State var noConnection: Bool = false
    
    var body: some View {
        VStack {
            if (projects == nil) {
                Spacer()
                ProgressView("Loading")
                Spacer()
            } else {
                RepositoriesView(projects: projects)
            }
        }.onAppear {
            Task.init {
                await getProjects()
            }
        }.navigationTitle("Repositories")
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

struct MemberReposView_Previews: PreviewProvider {
    static var previews: some View {
        MemberReposView()
    }
}
