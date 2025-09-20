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
		#if targetEnvironment(macCatalyst)
			NavigationSplitView {
				HomeView()
			} detail: {
				ContentUnavailableView("Welcome to Tanuki", systemImage: "house")
			}
		#else
			TabView {
				NavigationStack {
					HomeView()
				}.tabItem {
					Label("Home", systemImage: "house")
				}.tag(0)
				NavigationStack {
					EventsLoader()
				}.tabItem {
					Label("Activity", systemImage: "clock.arrow.circlepath")
				}.tag(1)
				NavigationStack {
					CurrentUserLoader()
				}.tabItem {
					Label("Account", systemImage: "person")
				}.tag(2)
			}
		#endif
	}
}
