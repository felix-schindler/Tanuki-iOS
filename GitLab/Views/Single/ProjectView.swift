//
//  ProjectView.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct ProjectView: View {
    @State var project: Project
    
    @State var showCommits: Bool = false
    @State var showBranches: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if (project.description != "") {
                    Text(project.description)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                VStack {
                    Text("Details")
                        .font(.headline)
                        .padding(.top)
                        .frame(maxWidth: .infinity, alignment: .leading)
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
                        VStack {
                            Text(project.nameWithNamespace)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Project ID: " + String(project.id))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    if (project.visibility == "private") {
                        Image(systemName: "lock")
                    } else if (project.visibility == "internal") {
                        Image(systemName: "shield.lefthalf.filled")
                    } else if (project.visibility == "public") {
                        Image(systemName: "globe")
                    }
                    Text(project.visibility.firstCapitalized)
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
                PipelineLoader(id: project.id, branch: project.defaultBranch, statusHorizontal: true)
            }.padding()
            HStack {
                Button(action: {showCommits = true}) {
                    Text("Commits")
                        .frame(maxWidth: .infinity)
                }.foregroundColor(.primary)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle)
                    .controlSize(.large)
                Button(action: {showBranches = true}) {
                    Text("Branches")
                        .frame(maxWidth: .infinity)
                }.foregroundColor(.primary)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle)
                    .controlSize(.large)
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
            FileLoader(id: project.id, filePath: "README.md", branch: project.defaultBranch)
        }.navigationTitle(project.name)
        .sheet(isPresented: $showCommits) {
            CommitsView(id: project.id, refName: project.defaultBranch)
        }
        .sheet(isPresented: $showBranches) {
            BranchesView(id: project.id)
        }
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView(project: Project(id: 0, description: "", name: "No project", nameWithNamespace: "", defaultBranch: "", sshUrlToRepo: "", httpUrlToRepo: "", forksCount: 0, starCount: 0, visibility: "", owner: UserSmall(id: 0, name: "", username: "", avatarUrl: ""), issuesEnabled: false, mergeRequestsEnabled: false))
    }
}
