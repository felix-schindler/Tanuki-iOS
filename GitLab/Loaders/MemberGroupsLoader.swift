//
//  MemberGroupsLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 24.01.22.
//

import SwiftUI

struct MemberGroupsLoader: View {
    @State var groups: [Group]? = nil
    @State var noConnection: Bool = false    

    var body: some View {
        VStack {
            if (groups != nil) {
                GroupListView(groups: groups!, updateFunction: getGroups)
            } else {
                if (noConnection) {
                    Text("Failed to load, please check your internet connection and your token")
                } else {
                    VStack {
                        Spacer()
                        ProgressView("Loading")
                        Spacer()
                    }
                }
            }
        }.onAppear {
            Task.init {
                await getGroups()
            }
        }.navigationTitle("Groups")
    }

    private func getGroups() async -> Void {
        do {
            let apiData: Data? = API.GET(endpoint: "groups")
            if (apiData != nil) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                groups = try decoder.decode([Group].self, from: apiData!)
            }
        } catch let jsonError as NSError {
            print("JSON error \(jsonError.localizedDescription)")
        }
    }
}

struct MemberGroupsLoader_Previews: PreviewProvider {
    static var previews: some View {
        MemberGroupsLoader()
    }
}
