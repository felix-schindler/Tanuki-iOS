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
	private var showSetup = API.host.isEmpty || API.token.isEmpty

	private func restorePersistedCookies() {
		guard
			let data = UserDefaults.standard.data(forKey: "persistedCookies"),
			let storedCookieDicts = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
				as? [[HTTPCookiePropertyKey: Any]],
			!storedCookieDicts.isEmpty
		else {
			Notify.status(.error, "No persisted cookies")
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

		let highlight =
			restoredCookies
			.filter { $0.name.starts(with: "_") }
			.map(\.name)
			.joined(separator: ", ")
		Notify.status(.success, highlight.isEmpty ? "Cookies restored" : "Cookies: \(highlight)")
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
				CurrentUserLoader(showSetup: $showSetup)
			}.tabItem {
				Label("Profile", systemImage: "person")
			}.tag(3)
		}.onAppear {
			restorePersistedCookies()
		}
	}
}
