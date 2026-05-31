//
//  CookiesView.swift
//  Tanuki
//
//  Created by Felix Schindler on 03.10.25.
//

#if canImport(WebKit)
import SwiftUI
import WebKit

struct CookiesView: View {
	@State var cookies: [HTTPCookie] = []
	@State var showingWebView = false

	private var loginUrl: URL {
		URL(string: "https://\(API.host)/users/sign_in")!
	}

	var body: some View {
		List {
			if cookies.isEmpty {
				Section {
					Text(
						"If you want to see profile pictures or contribution charts of users or groups that have a non-public visibility you'll need to also authenticate with cookies since personal access tokens are not sufficient to load that data."
					)
				}

				Section {
					VStack(alignment: .leading, spacing: 5) {
						Label("Click on the button below", systemImage: "1.circle.fill")
						Label("Make sure to check \"Remember me\"", systemImage: "2.circle.fill")
						Label("Log in to your GitLab account", systemImage: "3.circle.fill")
						Label("Dismiss the browser window when you finished logging in", systemImage: "4.circle.fill")
						Label(
							"If you start observing loading errors again repeat this process",
							systemImage: "5.circle.fill")
					}
					Button("Log In (Set Cookies)") {
						showingWebView = true
					}
				}
			} else {
				Section("Saved Cookies") {
					ForEach(cookies, id: \.identifier) { cookie in
						VStack(alignment: .leading) {
							Text(cookie.name).bold()
							Text(cookie.value)
								.font(.caption)
								.foregroundStyle(.secondary)
						}
					}
				}

				Section {
					Button(role: .destructive) {
						clearCookies()
					} label: {
						Text("Delete Cookies")
					}
				}
			}
		}
		.sheet(isPresented: $showingWebView, onDismiss: loadCookies) {
			WebLoginView(url: loginUrl)
		}
		.onAppear {
			loadCookies()
		}
		.navigationTitle("Cookies")
	}

	// Load cookies from WKWebsiteDataStore and persist them as property dictionaries
	private func loadCookies() {
		WKWebsiteDataStore.default().httpCookieStore.getAllCookies { all in
			let host = API.host.lowercased()
			let filtered = all.filter { $0.domain.lowercased().contains(host) }
			cookies = filtered
			persistCookies(filtered)
			syncToSharedCookieStorage(filtered)
		}
	}

	private func syncToSharedCookieStorage(_ cookies: [HTTPCookie]) {
		let shared = HTTPCookieStorage.shared
		for cookie in cookies {
			shared.setCookie(cookie)
		}
	}

	// Persist cookies as array of property dictionaries ([[HTTPCookiePropertyKey: Any]])
	// to match TanukiApp.restorePersistedCookies() expectations.
	private func persistCookies(_ cookies: [HTTPCookie]) {
		guard !cookies.isEmpty else { return }
		let propertyDicts: [[HTTPCookiePropertyKey: Any]] = cookies.compactMap { $0.properties }
		// Use legacy (non-secure) archiver; HTTPCookiePropertyKey dictionaries are property list safe.
		if let data = try? NSKeyedArchiver.archivedData(
			withRootObject: propertyDicts, requiringSecureCoding: false)
		{
			UserDefaults.standard.set(data, forKey: "persistedCookies")
		}
	}

	private func clearCookies() {
		let store = WKWebsiteDataStore.default().httpCookieStore
		store.getAllCookies { all in
			for cookie in all {
				store.delete(cookie)
			}
			cookies.removeAll()
			UserDefaults.standard.removeObject(forKey: "persistedCookies")
		}
	}
}
