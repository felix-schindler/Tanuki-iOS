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
								.foregroundStyle(.gray)
						}
					)
				}
				
				NavigationLink(destination: SnippetsLoader(public: true)) {
					Label(
						title: {
							Text("Snippets")
						},
						icon: {
							Image(systemName: "scissors")
								.foregroundStyle(.purple)
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
								.foregroundStyle(.red)
						}
					)
				}
				
				NavigationLink(destination: MemberLoader()) {
					Label(
						title: {
							Text("Users")
						},
						icon: {
							Image(systemName: "person.2")
								.foregroundStyle(.mint)
						}
					)
				}
				
				/* NavigationLink(destination: SnippetsLoader(public: true)) {
					Label(
						title: {
							Text("Topics")
						},
						icon: {
							Image(systemName: "tag")
								.foregroundStyle(.indigo)
						}
					)
				} */
			}.navigationTitle("Explore")
		}.navigationViewStyle(StackNavigationViewStyle())
	}
}

struct ExploreView_Previews: PreviewProvider {
	static var previews: some View {
		ExploreView()
	}
}
