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
        VStack {
            Text("meta")
                .font(.headline)
                .padding(.top)
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack {
                HStack {
                    Image(systemName: "folder")
                    Text(project.nameWithNamespace)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                HStack {
                    VStack {
                        Image(systemName: "fork.knife")
                        Text(String(project.forksCount))
                    }
                    VStack {
                        Image(systemName: "star")
                        Text(String(project.starCount))
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
            }.frame(maxWidth: .infinity, alignment: .leading)
            Text("project_id")
                .font(.headline)
                .padding(.top)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(String(project.id))
                .frame(maxWidth: .infinity, alignment: .leading)
            if (project.description != "") {
                Text("description")
                    .font(.headline)
                    .padding(.top)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(project.description)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack {
                Text("URL (http and ssh)")
                    .font(.headline)
                    .padding(.top)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Link(project.httpUrlToRepo, destination: URL(string: project.httpUrlToRepo)!)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Link(project.sshUrlToRepo, destination: URL(string: project.sshUrlToRepo)!)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
        }.padding()
        List {
            if (project.issuesEnabled) {
                NavigationLink(destination: ProjectIssuesLoader(project.id)) {
                    HStack {
                        Image(systemName: "square.on.square")
                        Text("Issues")
                        Spacer()
                        Text(String(project.openIssuesCount))
                    }
                }
            }
            if (project.mergeRequestsEnabled) {
                NavigationLink(destination: ProjectMergeLoader(project.id)) {
                    HStack {
                        Image(systemName: "arrow.merge")
                        Text("Merge Requests")
                    }
                }
            }
        }
        .navigationTitle(project.name)
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView(project: Project(id: 0, description: "", name: "No project", nameWithNamespace: "", httpUrlToRepo: "", sshUrlToRepo: "", forksCount: 0, starCount: 0))
    }
}
