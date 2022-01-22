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
                                if (project.visibility == "private") {
                                    Image(systemName: "lock")
                                } else if (project.visibility == "internal") {
                                    Image(systemName: "shield.lefthalf.filled")
                                } else if (project.visibility == "public") {
                                    Image(systemName: "globe")
                                }
                                Text(accessRole(code: project.permissions.projectAccess.accessLevel))
                                    .font(.caption)
                                    .padding(3)
                                    .background(.secondary)
                                    .cornerRadius(10)
                            }.frame(maxWidth: .infinity, alignment: .leading)
                            if (project.description != nil) {
                                Text(project.description!)
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
    
    func accessRole(code: Int) -> String {
        switch code {
        case 0:
            return "No access"
        case 5:
            return "Minimal access"
        case 10:
            return "Guest"
        case 20:
            return "Reporter"
        case 30:
            return "Developer"
        case 40:
            return "Maintainer"
        case 50:
            return "Owner"
        default:
            return ""
        }

    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView(projects: [Project](), updateFunction: {})
    }
}
