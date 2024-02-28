//
//  UserProjectsLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.02.24.
//

import GitLabAPI
import SwiftUI

struct UserProjectsLoader: View {
	@State
	private var memberShipNodes:
		[UserMembershipProjectsQuery.Data.CurrentUser.ProjectMemberships.Node?]? =
			nil

	@State
	private var loadFailed = false

	private func loadMembershipProjects() {
		Network.shared.apollo.fetch(query: UserMembershipProjectsQuery()) {
			result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting projects...")
				memberShipNodes =
					graphQLResult.data?.currentUser?.projectMemberships?.nodes
					?? []
			case .failure(let error):
				print("Failure! Error: \(error)")
				loadFailed = true
			}
		}
	}

	var body: some View {
		List {
			if let memberShips = self.memberShipNodes {
				if memberShips.isEmpty {
					Text("There are no projects")
				} else {
					ForEach(memberShips, id: \.?.hashValue) { memberShip in
						if let project = memberShip?.project {
							SmallProjectView(project)
						}
					}
				}
			} else {
				VStack {
					Image(systemName: "app.gift.fill")
						.resizable()
						.scaledToFit()
						.foregroundStyle(.gray)
						.frame(width: 50, height: 50)
					if loadFailed {
						Text("Failed to load project")
					} else {
						ProgressView("Loading project")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadMembershipProjects()
		}.refreshable {
			loadMembershipProjects()
		}.navigationTitle("Projects")
	}
}

#Preview {
	NavigationStack {
		UserProjectsLoader()
	}
}
