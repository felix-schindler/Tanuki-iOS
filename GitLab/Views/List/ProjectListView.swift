//
//  RepositoriesView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct ProjectListView: View {
    @State var projects: [Project]
    @State var updateFunction: () async -> Void

    var body: some View {
        List(projects, id: \.id) { project in
            NavigationLink(destination: ProjectView(project: project)) {
                Text(project.nameWithNamespace)
            }.swipeActions {
                Button {
                    print("Implement start project")
                } label: {
                    Image(systemName: "star")
                }.tint(.yellow)
            }
        }.refreshable {
            await updateFunction()
        }
    }

    /* private func starProject(id: Int) -> Bool {
        do {
            let apiData: Data? = API.POST(endpoint: "projects/"+String(id)+"/star")
            if (apiData != nil) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                projects = try decoder.decode([Project].self, from: apiData!)
                return false
            } else {
                return false
            }
        } catch let jsonError as NSError {
            print("JSON error \(jsonError.localizedDescription)")
            return false
        }
    } */
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView(projects: [Project]([Project(id: 1, description: "Test", name: "Test", nameWithNamespace: "test", httpUrlToRepo: "test", sshUrlToRepo: "test", forksCount: 0, starCount: 0)]), updateFunction: {})
    }
}
