//
//  Commits.swift
//  GitLab
//
//  Created by Felix Schindler on 02.11.21.
//

import SwiftUI

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
            VStack {
                if (commits != nil) {
                    if (commits!.isEmpty) {
                        Text("No commits")
                    } else {
                        HStack {
                            Text("On branch")
                            if (branches != nil) {
                                Picker("Branch", selection: $refName) {
                                    ForEach(branches!, id: \.name) { branch in
                                        Text(branch.name).tag(branch.name)
                                    }
                                }.pickerStyle(.menu)
                                .onChange(of: refName) { _ in
                                    Task.init { await getCommits() }
                                }
                            } else {
                                Picker("Branch", selection: $refName) {
                                    Text(refName).tag(refName)
                                }
                            }
                        }
                        List(commits!, id: \.id) { commit in
                            HStack {
                                Text(commit.title.emojized())
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text(commit.shortId)
                                    Text(commit.authorName)
                                }.foregroundColor(.secondary)
                                .font(.caption)
                            }
                        }.refreshable {
                            await getCommits()
                        }
                        Spacer()
                    }
                } else {
                    Spacer()
                    if (noConnection) {
                        Text("Failed to load, please check your internet connection and your token")
                            .foregroundColor(.red)
                    } else {
                        ProgressView("Loading")
                    }
                    Spacer()
                }
            }.onAppear {
                Task.init {
                    await getCommits()
                    await getBranches()
                }
            }.navigationBarTitle("Commits")
            .navigationBarItems(trailing: Button("Close", action: {self.presentationMode.wrappedValue.dismiss()}))
        }
    }
    
    private func getCommits() async -> Void {
        do {
            let apiData: Data? = API.GET(endpoint: "projects/" + String(id) + "/repository/commits?ref_name=" + refName)
            if (apiData != nil) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                commits = try decoder.decode([Commit].self, from: apiData!)
            } else {
                noConnection = true
            }
        } catch let jsonError as NSError {
            print("JSON error \(jsonError.localizedDescription)")
        }
    }
    
    private func getBranches() async -> Void {
        do {
            let apiData: Data? = API.GET(endpoint: "projects/" + String(id) + "/repository/branches")
            if (apiData != nil) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                branches = try decoder.decode([Branch].self, from: apiData!)
            } else {
                noConnection = true
            }
        } catch let jsonError as NSError {
            print("JSON error \(jsonError.localizedDescription)")
        }
    }
}

struct CommitsView_Previews: PreviewProvider {
    static var previews: some View {
        CommitsView(id: Int(), refName: String())
    }
}
