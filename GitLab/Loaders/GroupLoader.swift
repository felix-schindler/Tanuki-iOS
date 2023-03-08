//
//  GroupLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 08.03.23.
//

import SwiftUI

struct GroupLoader: View {
    @State var id: Int
    
    @State var group: Group? = nil
    @State var loadFailed: Bool = false
    
    var body: some View {
        VStack {
            if (group != nil) {
                GroupView(group: group!, updateFunction: getGroup)
            } else if (loadFailed) {
                Text("Failed to load, please check your internet connection and your token")
            } else {
                Spacer()
                ProgressView("Loading")
                Spacer()
            }
        }.onAppear {
            Task.init {
                await getGroup()
            }
        }
    }
    
    private func getGroup() async -> Void {
        group = await API.get(type: Group.self, endpoint: "groups/\(id)")
        loadFailed = (group == nil)
    }
}

struct GroupLoader_Previews: PreviewProvider {
    static var previews: some View {
        GroupLoader(id: 59430464)
    }
}
