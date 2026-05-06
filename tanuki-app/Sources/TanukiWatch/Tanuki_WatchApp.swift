//
//  Tanuki_WatchApp.swift
//  Tanuki Watch Watch App
//
//  Created by Felix Schindler on 20.09.25.
//

import SwiftUI

@main
struct Tanuki_Watch_Watch_AppApp: App {
	init() {
		WatchSync.shared.activate()
	}

    var body: some Scene {
		WindowGroup {
			ContentView()
        }
    }
}
