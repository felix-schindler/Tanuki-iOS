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
					InstancesListView()
						.navigationTitle("Instances")
				}
				.tag(0)
			} else {
				InstancesListView()
					.tag(0)
			}
			if #available(watchOS 9.0, *) {
				NavigationView {
					UserIssuesLoader()
						.navigationTitle("Issues")
				}
				.tag(1)
			} else {
				UserIssuesLoader()
					.tag(1)
			}
			if #available(watchOS 9.0, *) {
				NavigationView {
					MergeRequestsHomeView()
						.navigationTitle("Merge Requests")
				}
				.tag(2)
			} else {
				MergeRequestsHomeView()
					.tag(2)
			}
		}
	}
}

#Preview {
	ContentView()
}
