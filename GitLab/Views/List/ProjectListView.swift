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
                if (project.avatarUrl != nil) {
                    HStack {
                        AsyncImage(url: URL(string: project.avatarUrl)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                        } placeholder: {
                            ProgressView()
                        }.frame(width: 50, height: 50)
                        if (project.description != "") {
                            VStack {
                                Text(project.nameWithNamespace)
                                Text(project.description)
                                .foregroundColor(.secondary)
                            }
                        }
                    }
                } else {
                    if (project.description != "") {
                        VStack {
                            Text(project.nameWithNamespace)
                            Text(project.description)
                            .foregroundColor(.secondary)
                        }
                    } else {
                        Text(project.nameWithNamespace)
                    }
                }
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
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView(projects: [Project]([Project(id: 1, description: "Test", name: "Test", nameWithNamespace: "test", httpUrlToRepo: "test", sshUrlToRepo: "test", forksCount: 0, starCount: 0)]), updateFunction: {})
    }
}
