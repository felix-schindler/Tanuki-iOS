//
//  ContentView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct ContentView: View {
    @State var showChangeConf: Bool = false

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
            ExploreView()
                .tabItem {
                    Image(systemName: "safari")
                    Text("Explore")
                }
                .tag(1)
            AccountView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Account")
                }
                .tag(2)
        }.onAppear {
            showChangeConf = (API.base.isEmpty || API.token.isEmpty)
        }.sheet(isPresented: $showChangeConf) {
            ChangeConfigView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
