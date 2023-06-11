//
//  ExploreView.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct ExploreView: View {
	var body: some View {
		NavigationView {
			List {
				NavigationLink(destination: ProjectsLoader()) {
					Label(
						title: {
							Text("Projects")
						},
						icon: {
							Image(systemName: "appclip")
								.foregroundColor(.gray)
						}
					)
				}
				
				NavigationLink(destination: GroupsLoader(allAvailable: true)) {
					Label(
						title: {
							Text("Groups")
						},
						icon: {
							Image(systemName: "person.3")
								.foregroundColor(.red)
						}
					)
				}

				NavigationLink(destination: MemberLoader()) {
					Label("Users", systemImage: "person.2")
				}

				Label("Topics", systemImage: "tag")
				Label("Snippets", systemImage: "scissors")
			}.navigationTitle("Explore")
		}.navigationViewStyle(StackNavigationViewStyle())
	}
}

struct ExploreView_Previews: PreviewProvider {
	static var previews: some View {
		ExploreView()
	}
}
