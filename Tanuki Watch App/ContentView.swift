//
//  ContentView.swift
//  Tanuki Watch Watch App
//
//  Created by Felix Schindler on 20.09.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		TabView {
			if #available(watchOS 9.0, *) {
				NavigationView {
					UserIssuesLoader()
						.navigationTitle("Issues")
				}
				.tag(0)
			} else {
				UserIssuesLoader()
					.tag(0)
			}
			VStack {
				Image(systemName: "globe")
					.imageScale(.large)
					.foregroundStyle(.accent)
				Text("Hello, world!")
				Text("More coming soon...")
					.font(.callout)
					.foregroundStyle(.secondary)
			}.padding()
			.tag(1)
		}
    }
}

#Preview {
    ContentView()
}
