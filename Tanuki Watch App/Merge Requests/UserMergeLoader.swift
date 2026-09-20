//
//  UserMergeLoader.swift
//  Tanuki Watch App
//
//  Created by Felix Schindler on 28.02.24.
//

import Apollo
import GitLabAPI
import SwiftUI

enum UserMergeRequestType {
	case assigned
	case authored
	case reviewRequested
}

struct UserMergeLoader: View {
	private var userRequestType: UserMergeRequestType
	private var navTitle: String

	@State
	private var mergeRequests: Result<[any SmallMergeRequest], Error>? = nil

	init(_ userRequestType: UserMergeRequestType) {
		self.userRequestType = userRequestType

		self.navTitle =
			switch self.userRequestType {
			case .assigned:
				"Assigned MRs"
			case .authored:
				"Authored MRs"
			case .reviewRequested:
				"Review Requests"
			}
	}

	private func loadMergeRequests() {
		do {
			switch self.userRequestType {
			case .assigned:
				let responses = try Network.shared.apollo.fetch(
					query: UserAssignedMergeRequestsQuery(state: .none, search: .none, draft: .none, subscribed: .none),
					cachePolicy: .cacheAndNetwork
				)

				Task {
					for try await response in responses {
						if let mrs = response.data?.currentUser?.assignedMergeRequests?.nodes {
							let mapped: [any SmallMergeRequest] = mrs.compactMap { $0 }
							self.mergeRequests = .success(mapped)
						}
					}
				}
			case .authored:
				let responses = try Network.shared.apollo.fetch(
					query: UserAuthoredMergeRequestsQuery(state: .none, search: .none, draft: .none, subscribed: .none),
					cachePolicy: .cacheAndNetwork
				)

				Task {
					for try await response in responses {
						if let mrs = response.data?.currentUser?.authoredMergeRequests?.nodes {
							let mapped: [any SmallMergeRequest] = mrs.compactMap { $0 }
							self.mergeRequests = .success(mapped)
						}
					}
				}
			case .reviewRequested:
				let responses = try Network.shared.apollo.fetch(
					query: UserReviewRequestedMergeRequestsQuery(state: .none, search: .none, draft: .none, subscribed: .none),
					cachePolicy: .cacheAndNetwork
				)

				Task {
					for try await response in responses {
						if let mrs = response.data?.currentUser?.reviewRequestedMergeRequests?.nodes {
							let mapped: [any SmallMergeRequest] = mrs.compactMap { $0 }
							self.mergeRequests = .success(mapped)
						}
					}
				}
			}
		} catch let error {
			self.mergeRequests = .failure(error)
		}
	}

	private func reloadMergeRequests() async {
		do {
			switch self.userRequestType {
			case .assigned:
				let response = try await Network.shared.apollo.fetch(
					query: UserAssignedMergeRequestsQuery(state: .none, search: .none, draft: .none, subscribed: .none),
					cachePolicy: .networkOnly
				)

				if let mrs = response.data?.currentUser?.assignedMergeRequests?.nodes {
					let mapped: [any SmallMergeRequest] = mrs.compactMap { $0 }
					self.mergeRequests = .success(mapped)
				}
			case .authored:
				let response = try await Network.shared.apollo.fetch(
					query: UserAuthoredMergeRequestsQuery(state: .none, search: .none, draft: .none, subscribed: .none),
					cachePolicy: .networkOnly
				)

				if let mrs = response.data?.currentUser?.authoredMergeRequests?.nodes {
					let mapped: [any SmallMergeRequest] = mrs.compactMap { $0 }
					self.mergeRequests = .success(mapped)
				}
			case .reviewRequested:
				let response = try await Network.shared.apollo.fetch(
					query: UserReviewRequestedMergeRequestsQuery(state: .none, search: .none, draft: .none, subscribed: .none),
					cachePolicy: .networkOnly
				)

				if let mrs = response.data?.currentUser?.reviewRequestedMergeRequests?.nodes {
					let mapped: [any SmallMergeRequest] = mrs.compactMap { $0 }
					self.mergeRequests = .success(mapped)
				}
			}
		} catch let error {
			self.mergeRequests = .failure(error)
		}
	}

	public var body: some View {
		List {
			if let mergeRequests {
				switch mergeRequests {
				case .success(let mergeRequests):
					if mergeRequests.isEmpty {
						NoContentView("There are no merge requests", systemImage: "arrow.triangle.branch")
					} else {
						ForEach(0..<mergeRequests.count, id: \.self) { index in
							let mr = mergeRequests[index]
							SmallMergeView(mr._project.fullPath, mr)
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				ProgressView("Loading merge requests")
			}
		}
		.onAppear {
			loadMergeRequests()
		}
		.refreshable {
			await reloadMergeRequests()
		}
		.navigationTitle(self.navTitle)
	}
}

#Preview {
	NavigationView {
		UserMergeLoader(.authored)
	}
}
