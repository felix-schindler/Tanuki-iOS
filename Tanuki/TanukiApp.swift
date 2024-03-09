//
//  TanukiApp.swift (GitLabApp.swift)
//  Tanuki (GitLab)
//
//  Created by Felix Schindler on 30.10.21.
//  Rewritten by Felix Schindler on 26.02.24.
//

import SwiftUI

@main
struct TanukiApp: App {
	@State
	public var showChangeConf = API.host.isEmpty || API.token.isEmpty
	
	public var body: some Scene {
		WindowGroup {
			TabView {
				NavigationStack {
					HomeView()
				}.tabItem {
					Label("Home", systemImage: "house")
				}.tag(0)
				NavigationStack {
					CurrentUserLoader()
				}.tabItem {
					Label("Account", systemImage: "person")
				}.tag(1)
			}.sheet(isPresented: $showChangeConf) {
				SettingsView(isPresented: $showChangeConf)
			}
		}
	}
}
