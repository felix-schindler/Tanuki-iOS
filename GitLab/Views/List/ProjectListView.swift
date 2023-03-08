//
//  RepositoriesView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI
import MarkdownUI

struct ProjectListView: View {
    @State var projects: [Project]
    @State var updateFunction: () async -> Void

    var body: some View {
        if (projects.isEmpty) {
            Text("There are no projects")
        } else {
            List(projects, id: \.id) { project in
                NavigationLink(destination: ProjectView(project: project)) {
                    HStack {
                        if (project.avatarUrl != nil || project.namespace.avatarUrl != nil) {
                            AsyncImage(url: URL(string: project.avatarUrl ?? API.domain + project.namespace.avatarUrl!)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(10)
                                default:
                                    Image(systemName: "exclamationmark.icloud")
                                        .resizable()
                                        .scaledToFit()
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
                                if (project.permissions != nil && project.permissions!.projectAccess != nil) {
                                    Text(accessRole(code: project.permissions!.projectAccess!.accessLevel))
                                        .font(.caption)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 4)
                                        .background(Color(.systemGray3))
                                        .cornerRadius(10)
                                }
                            }.frame(maxWidth: .infinity, alignment: .leading)
                            if (project.description != nil && project.description != "") {
                                Markdown(project.description!.emojized())
                                    .markdownTextStyle {
                                        ForegroundColor(.secondary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            VStack {
                                HStack {
                                    HStack(spacing: 1) {
                                        Image(systemName: "star")
                                        Text(String(project.starCount))
                                    }

                                    if (project.forksCount != nil) {
                                        HStack(spacing: 1) {
                                            Image(systemName: "arrow.branch")
                                            Text(String(project.forksCount!))
                                        }
                                    }

                                    if (project.issuesEnabled && project.openIssuesCount != nil) {
                                        HStack(spacing: 1) {
                                            Image(systemName: "smallcircle.circle")
                                            Text(String(project.openIssuesCount!))
                                        }
                                    }
                                }.frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 0.25)
                                if (!project.tagList.isEmpty) {
                                    HStack {
                                        ForEach(project.tagList, id: \.hashValue) { tag in
                                            Text(tag)
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 4)
                                                .background(Color(.systemGray3))
                                                .cornerRadius(10)
                                                .foregroundColor(.primary)
                                        }
                                    }.frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }.font(.caption)
                             .foregroundColor(.secondary)
                        }
                    }
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
        ProjectListView(projects: [], updateFunction: {})
    }
}
