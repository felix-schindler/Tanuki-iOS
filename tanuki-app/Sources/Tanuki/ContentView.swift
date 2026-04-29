//
//  TanukiApp.swift (GitLabApp.swift)
//  Tanuki (GitLab)
//
//  Created by Felix Schindler on 30.10.21.
//  Rewritten by Felix Schindler on 26.02.24.
//  Rewritten by Felix Schindler again on 11.04.26 when moving to Skip.
//

import SwiftUI
import WebKit

enum ContentTab: String, Hashable {
	case home, todos, explore, profile
}

struct ContentView: View {
	@AppStorage("tab") var tab = ContentTab.home
	public var showSetup: Binding<Bool>

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

	public var body: some View {
		TabView(selection: $tab) {
			NavigationView {
				HomeView()
			}.tabItem {
				Label("Home", systemImage: "house")
			}.tag(ContentTab.home)
			NavigationView {
				CurrentUserTodosLoader()
			}.tabItem {
				Label("Todos", systemImage: "checkmark.square")
			}.tag(ContentTab.todos)
			NavigationView {
				ExploreView()
			}.tabItem {
				Label("Explore", systemImage: "sparkles")
			}.tag(ContentTab.explore)
			NavigationView {
				CurrentUserLoader()
			}.tabItem {
				Label("Profile", systemImage: "person")
			}.tag(ContentTab.profile)
		}.onAppear {
			restorePersistedCookies()
		}
	}
}
