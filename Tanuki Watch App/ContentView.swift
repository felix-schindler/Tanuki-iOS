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
			NavigationStack {
				InstancesListView()
			}
			.tag(0)

			NavigationStack {
				UserIssuesLoader()
					.navigationTitle("Issues")
			}
			.tag(1)

			NavigationStack {
				MergeRequestsHomeView()
			}
			.tag(2)
		}
	}
}

#Preview {
	ContentView()
}
