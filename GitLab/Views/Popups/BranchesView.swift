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
            if (branches != nil) {
                if (branches!.isEmpty) {
                    Text("You'll see your branches after you pushed them")
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
                            PipelineLoader(id: id, branch: branch.name)
                        }
                    }.refreshable {
                        await getBranches()
                    }.navigationBarTitle("Branches")
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
                }.navigationBarTitle("Branches")
                .navigationBarItems(trailing: Button("Close", action: {self.presentationMode.wrappedValue.dismiss()}))
            }
        }.onAppear {
            Task.init {
                await getBranches()
            }
        }
    }
    
    private func getBranches() async -> Void {
        branches = await API.get(type: [Branch].self, endpoint: "projects/\(id)/repository/branches")
        noConnection = branches == nil
    }
}

struct BranchesView_Previews: PreviewProvider {
    static var previews: some View {
        BranchesView(id: Int())
    }
}
