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
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "safari")
                }
                .tag(1)
            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person")
                }
                .tag(2)
        }.onAppear {
            showChangeConf = (API.domain.isEmpty || API.token.isEmpty)
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
