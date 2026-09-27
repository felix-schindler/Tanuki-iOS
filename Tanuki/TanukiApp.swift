//
//  TanukiApp.swift (GitLabApp.swift)
//  Tanuki (GitLab)
//
//  Created by Felix Schindler on 30.10.21.
//  Rewritten by Felix Schindler on 26.02.24.
//

import OSLog
import SwiftUI
import WebKit

let logger: Logger = Logger(subsystem: "de.schindlerfelix.GitLab", category: "Tanuki")

@main
struct TanukiApp: App {
	@StateObject
	private var sessionStore = SessionStore.shared

	init() {
		InstanceManager.migrate()
		WatchSync.shared.activate()
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
			main
				.fullScreenCover(
					isPresented: Binding(
						get: { sessionStore.needsSetup },
						set: { newValue in
							if !newValue {
								sessionStore.setNeedsSetup(false)
							}
						}
					)
				) {
					SetupView()
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
				CurrentUserLoader()
			}.tabItem {
				Label("Profile", systemImage: "person")
			}.tag(3)
		}.onAppear {
			sessionStore.refresh()
			restorePersistedCookies()
		}
	}
}
