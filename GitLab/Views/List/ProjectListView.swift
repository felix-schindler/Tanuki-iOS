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
        if (projects.isEmpty) {
            Text("No projects")
        } else {
            List(projects, id: \.id) { project in
                NavigationLink(destination: ProjectView(project: project)) {
                    HStack {
                        if (project.avatarUrl != nil || project.owner != nil) {
                            AsyncImage(url: URL(string: project.avatarUrl ?? project.owner!.avatarUrl)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(10)
                                case .failure:
                                    Text("Failed to load")
                                @unknown default:
                                    Text("Unkown error")
                                }
                            }.frame(width: 50, height: 50, alignment: .leading)
                        }
                        VStack {
                            HStack {
                                Text(project.nameWithNamespace)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                if (project.visibility == "private") {
                                    Image(systemName: "lock")
                                } else if (project.visibility == "internal") {
                                    Image(systemName: "shield.lefthalf.filled")
                                } else if (project.visibility == "public") {
                                    Image(systemName: "globe")
                                }
                            }
                            if (project.description != "") {
                                Text(project.description)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
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
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView(projects: [Project](), updateFunction: {})
    }
}
