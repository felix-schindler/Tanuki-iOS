//
//  MergeRequestsHomeView.swift
//  Tanuki Watch App
//
//  Created by Felix Schindler on 12.04.26.
//

import SwiftUI

struct MergeRequestsHomeView: View {
	public var body: some View {
		List {
			NavigationLink("Assigned", destination: UserMergeLoader(.assigned))
			NavigationLink("Authored", destination: UserMergeLoader(.authored))
			NavigationLink("Review Requested", destination: UserMergeLoader(.reviewRequested))
		}
		.navigationTitle("Merge Requests")
	}
}

#Preview {
	NavigationView {
		MergeRequestsHomeView()
	}
}
