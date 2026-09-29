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
			NavigationView {
				InstancesListView()
					.navigationTitle("Instances")
			}
			.tag(0)

			NavigationView {
				UserIssuesLoader()
					.navigationTitle("Issues")
			}
			.tag(1)

			NavigationView {
				MergeRequestsHomeView()
					.navigationTitle("Merge Requests")
			}
			.tag(2)
		}
	}
}

#Preview {
	ContentView()
}
