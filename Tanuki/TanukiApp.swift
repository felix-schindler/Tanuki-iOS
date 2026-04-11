//
//  TanukiApp.swift (GitLabApp.swift)
//  Tanuki (GitLab)
//
//  Created by Felix Schindler on 30.10.21.
//  Rewritten by Felix Schindler on 26.02.24.
//

import SwiftUI
import WebKit

@main
struct TanukiApp: App {
	@State
	private var showSetup = false

	init() {
		InstanceManager.migrate()
		showSetup = InstanceManager.selected == nil
	}

	private func restorePersistedCookies() {
		guard
			let data = UserDefaults.standard.data(forKey: "persistedCookies"),
			let storedCookieDicts = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
				as? [[HTTPCookiePropertyKey: Any]],
			!storedCookieDicts.isEmpty
		else {
			return
		}

		let webStore = WKWebsiteDataStore.default().httpCookieStore
		var restoredCookies: [HTTPCookie] = []
		for dict in storedCookieDicts {
			if let cookie = HTTPCookie(properties: dict) {
				restoredCookies.append(cookie)
				webStore.setCookie(cookie)
				HTTPCookieStorage.shared.setCookie(cookie)  // sync to URLSession
			}
		}
	}

	public var body: some Scene {
		WindowGroup {
			if showSetup {
				SetupView(showSetup: $showSetup)
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
				CurrentUserTodosLoader()
			}.tabItem {
				Label("Todos", systemImage: "checkmark.square")
			}.tag(1)
			NavigationView {
				ExploreView()
			}.tabItem {
				Label("Explore", systemImage: "sparkles")
			}.tag(2)
			NavigationView {
				CurrentUserLoader(showSetup: $showSetup)
			}.tabItem {
				Label("Profile", systemImage: "person")
			}.tag(3)
		}.onAppear {
			restorePersistedCookies()
		}
	}
}
