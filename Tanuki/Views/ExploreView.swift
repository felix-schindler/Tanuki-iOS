//
//  ExploreView.swift
//  Tanuki
//
//  Created by Felix Schindler on 20.09.25.
//

import SwiftUI

struct ExploreView: View {
	var body: some View {
		List {
			Label(
				title: {
					Text("Projects")
				},
				icon: {
					Image(systemName: "app.gift.fill")
						.foregroundStyle(.gray)
				})
			Label(
				title: {
					Text("Snippets")
				},
				icon: {
					Image(systemName: "scissors")
						.foregroundStyle(.purple)
				})
			Label(
				title: {
					Text("Groups")
				},
				icon: {
					Image(systemName: "scale.3d")
						.foregroundStyle(.red)
				})
			Label(
				title: {
					Text("Users")
				},
				icon: {
					Image(systemName: "person.2")
						.foregroundStyle(.cyan)
				})
		}.navigationTitle("Explore")
	}
}

#Preview {
	NavigationStack {
		ExploreView()
	}
}
