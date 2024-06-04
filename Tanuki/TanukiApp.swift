//
//  TanukiApp.swift (GitLabApp.swift)
//  Tanuki (GitLab)
//
//  Created by Felix Schindler on 30.10.21.
//  Rewritten by Felix Schindler on 26.02.24.
//

import AlertToast
import SwiftUI

@main
struct TanukiApp: App {
	private var showSetup = API.host.isEmpty || API.token.isEmpty

	@State
	public var showToast = false

	@State
	public var toast: AlertToast? = nil

	public var body: some Scene {
		WindowGroup {
			if showSetup {
				SetupView()
			} else {
				main
					.toast(
						isPresenting: $showToast,
						alert: {
							if let toast {
								toast
							} else {
								AlertToast(
									displayMode: .hud,
									type: .error(.red),
									title: "This is a bug",
									subTitle:
										"Kindly report this issue on GitLab or via email, providing details about your activities leading up to this occurrence"
								)
							}
						})
			}
		}
	}

	public var main: some View {
		#if os(iOS)
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
		#else
			NavigationSplitView {
				HomeView()
			} detail: {
				Text("Welcome to Tanuki")
			}
		#endif
	}
}
