//
//  UserProjectsLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.02.24.
//

import GitLabAPI
import SwiftUI

struct UserProjectsLoader: View {
	private let username: String?

	@State
	private var memberShipNodes: [ProjectMembership?]? = nil

	@State
	private var loadFailed = false

	init(username: String? = nil) {
		self.username = username
	}

	private func loadMembershipProjects() {
		if let user = username {
			Network.shared.apollo.fetch(
				query: UserMembershipProjectsQuery(username: user)
			) {
				result in
				switch result {
				case .success(let graphQLResult):
					print("Success! Setting projects...")
					memberShipNodes =
						graphQLResult.data?.user?.projectMemberships?.nodes
						?? []
				case .failure(let error):
					print("Failure! Error: \(error)")
					loadFailed = true
				}
			}
		} else {
			Network.shared.apollo.fetch(
				query: CurrentUserMembershipProjectsQuery()
			) {
				result in
				switch result {
				case .success(let graphQLResult):
					print("Success! Setting projects...")
					memberShipNodes =
						graphQLResult.data?.currentUser?.projectMemberships?
						.nodes
						?? []
				case .failure(let error):
					print("Failure! Error: \(error)")
					loadFailed = true
				}
			}
		}
	}

	var body: some View {
		List {
			if let memberShips = self.memberShipNodes {
				if memberShips.isEmpty {
					Text("There are no projects")
				} else {
					ForEach(memberShips, id: \.?._project?.fullPath) {
						memberShip in
						if let project = memberShip?._project {
							VStack(alignment: .leading) {
								SmallProjectView(project)
							}
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
						Text(loadFailedMsg)
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
		UserProjectsLoader(username: "felix-schindler")
	}
}
