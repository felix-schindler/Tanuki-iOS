//
//  GitLabApp.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

@main
struct GitLabApp: App {
	@State var showChangeConf: Bool = API.domain.isEmpty || API.token.isEmpty
	
	var body: some Scene {
		WindowGroup {
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
			}.sheet(isPresented: $showChangeConf) {
				SettingsView()
			}
		}
	}
}
