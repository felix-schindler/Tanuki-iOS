//
//  Commits.swift
//  GitLab
//
//  Created by Felix Schindler on 02.11.21.
//

import SwiftUI
// import MarkdownUI

struct CommitsView: View {
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>

    @State var id: Int
    @State var refName: String

    @State var branches: [Branch]? = nil

    @State var commits: [Commit]? = nil
    @State var noConnection: Bool = false

    var body: some View {
        NavigationView {
            if (commits != nil) {
                if (commits!.isEmpty) {
                    Text("No commits")
                } else {
                    List {
                        HStack {
                            Text("On branch")
                            if (branches != nil) {
                                Picker("", selection: $refName) {
                                    ForEach(branches!, id: \.name) { branch in
                                        Text(branch.name).tag(branch.name)
                                    }
                                }.pickerStyle(.menu)
                                .onChange(of: refName) { _ in
                                    Task.init { await getCommits() }
                                }
                            } else {
                                Picker("", selection: $refName) {
                                    Text(refName).tag(refName)
                                }.pickerStyle(.menu)
                            }
                        }
                        Section("Commits") {
                            ForEach(commits!, id: \.id) { commit in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(commit.title.emojized())
                                        // Markdown(Document(commit.message.emojized()))
                                        // Text(commit.message.emojized())
                                        Text(commit.authorName + " · " + commit.authoredDate.toString())
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text(commit.shortId)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }.headerProminence(.increased)
                    }.refreshable {
                        await getCommits()
                    }.navigationBarTitle("Commits")
                    .navigationBarItems(trailing: Button("Close", action: {self.presentationMode.wrappedValue.dismiss()}))
                }
            } else {
                VStack {
                    Spacer()
                    if (noConnection) {
                        Text("Failed to load, please check your internet connection and your token")
                            .foregroundColor(.red)
                    } else {
                        ProgressView("Loading")
                    }
                    Spacer()
                }.navigationBarTitle("Commits")
                .navigationBarItems(trailing: Button("Close", action: {self.presentationMode.wrappedValue.dismiss()}))
            }
        }.onAppear {
            Task.init {
                await getCommits()
                await getBranches()
            }
        }
    }

    private func getCommits() async -> Void {
        commits = await API.get(type: [Commit].self, endpoint: "projects/\(id)/repository/commits?ref_name=\(refName)")
        noConnection = commits == nil
    }

    private func getBranches() async -> Void {
        branches = await API.get(type: [Branch].self, endpoint: "projects/\(id)/repository/branches")
        noConnection = branches == nil
    }
}

struct CommitsView_Previews: PreviewProvider {
    static var previews: some View {
        CommitsView(id: Int(), refName: String())
    }
}
