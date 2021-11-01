//
//  ProjectView.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct ProjectView: View {
    @State var project: Project
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Details")
                    .font(.headline)
                if (project.description != "") {
                    Text(project.description)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                HStack {
                    if (project.avatarUrl != nil) {
                        AsyncImage(url: URL(string: project.avatarUrl!)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(10)
                            case .failure:
                                EmptyView()
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                    Text(project.nameWithNamespace)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                HStack {
                    HStack {
                        Image(systemName: "star")
                        Text(String(project.starCount) + " stars")
                    }
                    Text(" · ")
                    HStack {
                        Image(systemName: "tuningfork")
                        Text(String(project.forksCount) + " forks")
                    }
                }
            }.padding()
            VStack(alignment: .leading) {
                Text("Issues and Merge Requests")
                    .font(.headline)
                if (project.issuesEnabled) {
                    NavigationLink(destination: ProjectIssuesLoader(id: project.id)) {
                        HStack {
                            Image(systemName: "square.on.square")
                            Text("Issues")
                            Spacer()
                            Text(String(project.openIssuesCount!))
                        }
                    }.foregroundColor(.primary)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle)
                    .controlSize(.large)
                }
                if (project.mergeRequestsEnabled) {
                    NavigationLink(destination: ProjectMergeLoader(id: project.id)) {
                        HStack {
                            Image(systemName: "arrow.merge")
                            Text("Merge Requests")
                            Spacer()
                        }
                    }.foregroundColor(.primary)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle)
                    .controlSize(.large)
                }
            }.padding(.horizontal)
        }
        .navigationTitle(project.name)
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView(project: Project(id: 0, description: "", name: "No project", nameWithNamespace: "", sshUrlToRepo: "", httpUrlToRepo: "", forksCount: 0, starCount: 0, visibility: "", owner: UserSmall(id: 0, name: "", username: "", avatarUrl: ""), issuesEnabled: false, mergeRequestsEnabled: false))
    }
}
