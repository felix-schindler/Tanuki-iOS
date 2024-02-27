//
//  TanukiApp.swift
//  Tanuki
//
//  Created by Felix Schindler on 26.02.24.
//

import SwiftUI

@main
struct TanukiApp: App {
    var body: some Scene {
        WindowGroup {
			NavigationStack {
				StarredProjects()
			}
        }
    }
}
