//
//  BranchesView.swift
//  GitLab
//
//  Created by Felix Schindler on 02.11.21.
//

import SwiftUI

struct BranchesView: View {
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>

    @State var id: Int
    
    @State var branches: [Branch]? = nil
    @State var noConnection: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if (branches != nil) {
                    if (branches!.isEmpty) {
                        Text("No branches")
                    } else {
                        List(branches!, id: \.name) { branch in
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        if (branch.protected) {
                                            Image(systemName: "lock")
                                        }
                                        Text(branch.name.emojized())
                                            .font(.headline)
                                    }
                                    Text(branch.commit.shortId + " · " + branch.commit.title.emojized())
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                VStack {
                                    Text("Merged: " + String(branch.merged))
                                    Text("Can push: " + String(branch.canPush))
                                }
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
                }
            }.navigationBarTitle("Branches")
            .navigationBarItems(trailing: Button("Close", action: {self.presentationMode.wrappedValue.dismiss()}))
        }
    }
    
    private func getCommits() async -> Void {
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

struct BranchesView_Previews: PreviewProvider {
    static var previews: some View {
        BranchesView(id: Int())
    }
}
