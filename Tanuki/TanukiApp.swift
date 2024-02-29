//
//  TanukiApp.swift
//  Tanuki
//
//  Created by Felix Schindler on 26.02.24.
//

import SwiftUI

@main
struct TanukiApp: App {
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
			}
		}
	}
}
