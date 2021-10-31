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
                        AsyncImage(url: URL(string: project.avatarUrl!)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(10)
                            case .failure:
                                Text("img_load_err")
                            @unknown default:
                                Text("unkown_err")
                            }
                        }.frame(width: 50, height: 50, alignment: .leading)
                        VStack {
                            Text(project.nameWithNamespace)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            if (project.description != "") {
                                Text(project.description)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                } else {
                    if (project.description != "") {
                        VStack {
                            Text(project.nameWithNamespace)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(project.description)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    } else {
                        Text(project.nameWithNamespace)
                            .frame(maxWidth: .infinity, alignment: .leading)
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
        ProjectListView(projects: [Project](), updateFunction: {})
    }
}
