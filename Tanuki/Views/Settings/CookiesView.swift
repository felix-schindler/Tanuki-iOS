import SwiftHttp
import SwiftUI
import WebKit

struct CookiesView: View {
	@State private var cookies: [HTTPCookie] = []
	@State private var showingWebView = false

	private let loginUrl = HttpUrl(host: API.host, path: ["users", "sign_in"]).url

	var body: some View {
		List {
			if cookies.isEmpty {
				Section {
					VStack(alignment: .leading) {
						Label("Click on the button below", systemImage: "1.circle.fill")
						Label("Make sure to check \"Remember me\"", systemImage: "2.circle.fill")
						Label("Log in to your GitLab account", systemImage: "3.circle.fill")
						Label("Dismiss the browser window", systemImage: "4.circle.fill")
					}
					Button("Log In (Set Cookies)") {
						showingWebView = true
					}
				}
			} else {
				Section("Saved Cookies") {
					ForEach(cookies, id: \.name) { cookie in
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
		}.sheet(isPresented: $showingWebView, onDismiss: loadCookies) {
			WebLoginView(url: loginUrl)
		}.onAppear {
			loadCookies()
		}.navigationTitle("Cookies")
	}

	private func loadCookies() {
		WKWebsiteDataStore.default().httpCookieStore.getAllCookies { newCookies in
			cookies = newCookies
		}
	}

	private func clearCookies() {
		let store = WKWebsiteDataStore.default().httpCookieStore
		store.getAllCookies { all in
			for cookie in all {
				store.delete(cookie)
			}
			cookies.removeAll()
		}
	}
}

struct WebLoginView: UIViewRepresentable {
	let url: URL

	func makeCoordinator() -> Coordinator { Coordinator() }

	func makeUIView(context: Context) -> WKWebView {
		let config = WKWebViewConfiguration()
		config.websiteDataStore = .default()
		let webView = WKWebView(frame: .zero, configuration: config)
		let request = URLRequest(url: url)
		webView.load(request)
		context.coordinator.webView = webView
		return webView
	}

	func updateUIView(_ uiView: WKWebView, context: Context) {}

	class Coordinator: NSObject, WKNavigationDelegate {
		weak var webView: WKWebView?
	}
}
