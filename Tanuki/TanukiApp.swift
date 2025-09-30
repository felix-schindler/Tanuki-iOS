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
	private var showSetup = API.host.isEmpty || API.token.isEmpty

	public var body: some Scene {
		WindowGroup {
			if showSetup {
				SetupView()
			} else {
				main
			}
		}
	}

	public var main: some View {
		TabView {
			NavigationView {
				HomeView()
			}.tabItem {
				Label("Home", systemImage: "house")
			}.tag(0)
			NavigationView {
				EventsLoader()
			}.tabItem {
				Label("Activity", systemImage: "bell")
			}.tag(1)
			NavigationView {
				ExploreView()
			}.tabItem {
				Label("Explore", systemImage: "sparkles")
			}.tag(2)
			NavigationView {
				CurrentUserLoader()
			}.tabItem {
				Label("Profile", systemImage: "person")
			}.tag(3)
		}
	}
}
