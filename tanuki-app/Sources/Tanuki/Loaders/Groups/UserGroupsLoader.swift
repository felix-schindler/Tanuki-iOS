//
//  UserGroupsLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.02.24.
//

import GitLabAPI
import SwiftUI

struct UserGroupsLoader: View {
	private let username: String

	@State var groups: Result<[GitLabAPI.Group], Error>? = nil

	init(_ username: String) {
		self.username = username
	}

	private func loadGroups() {
		Task {
			do {
				let groups = try await Network.shared.service.fetchUserGroups(username: username)
				self.groups = .success(groups)
			} catch let error {
				self.groups = .failure(error)
				Notify.status(.error)
			}
		}
	}

	private func reloadGroups() async {
		do {
			let groups = try await Network.shared.service.fetchUserGroups(username: username)
			self.groups = .success(groups)
			Notify.status(.success)
		} catch let error {
			self.groups = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if let groups {
				switch groups {
				case .success(let groups):
					if groups.isEmpty {
						NoContentView("There are no groups", systemImage: "scale.3d")
					} else {
						ForEach(groups, id: \.fullPath) { group in
							SmallGroupView(group: group)
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading Groups", systemImage: "scale.3d")
			}
		}.onAppear {
			loadGroups()
		}.refreshable {
			await reloadGroups()
		}.navigationTitle("Groups")
	}
}

#Preview {
	NavigationView {
		UserGroupsLoader("felix-schindler")
	}
}
