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

	@State
	private var loadTask: Task<Void, Never>?

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

	private func loadFromCache() async -> Result<[any SmallMergeRequest], Error> {
		do {
			switch self.userRequestType {
			case .assigned:
				let query = UserAssignedMergeRequestsQuery(
					state: .none, search: .none, draft: .none, subscribed: .none)
				let responses = try Network.shared.apollo.fetch(query: query, cachePolicy: .cacheAndNetwork)
				for try await response in responses {
					if Task.isCancelled { return .success([]) }
					if let mrs = response.data?.currentUser?.assignedMergeRequests?.nodes {
						return .success(mrs.compactMap { $0 })
					}
				}
			case .authored:
				let query = UserAuthoredMergeRequestsQuery(
					state: .none, search: .none, draft: .none, subscribed: .none)
				let responses = try Network.shared.apollo.fetch(query: query, cachePolicy: .cacheAndNetwork)
				for try await response in responses {
					if Task.isCancelled { return .success([]) }
					if let mrs = response.data?.currentUser?.authoredMergeRequests?.nodes {
						return .success(mrs.compactMap { $0 })
					}
				}
			case .reviewRequested:
				let query = UserReviewRequestedMergeRequestsQuery(
					state: .none, search: .none, draft: .none, subscribed: .none)
				let responses = try Network.shared.apollo.fetch(query: query, cachePolicy: .cacheAndNetwork)
				for try await response in responses {
					if Task.isCancelled { return .success([]) }
					if let mrs = response.data?.currentUser?.reviewRequestedMergeRequests?.nodes {
						return .success(mrs.compactMap { $0 })
					}
				}
			}
			return .success([])
		} catch let error {
			return .failure(error)
		}
	}

	private func loadFromNetwork() async -> Result<[any SmallMergeRequest], Error> {
		do {
			switch self.userRequestType {
			case .assigned:
				let response = try await Network.shared.apollo.fetch(
					query: UserAssignedMergeRequestsQuery(
						state: .none, search: .none, draft: .none, subscribed: .none),
					cachePolicy: .networkOnly)
				let mrs = response.data?.currentUser?.assignedMergeRequests?.nodes ?? []
				return .success(mrs.compactMap { $0 })
			case .authored:
				let response = try await Network.shared.apollo.fetch(
					query: UserAuthoredMergeRequestsQuery(
						state: .none, search: .none, draft: .none, subscribed: .none),
					cachePolicy: .networkOnly)
				let mrs = response.data?.currentUser?.authoredMergeRequests?.nodes ?? []
				return .success(mrs.compactMap { $0 })
			case .reviewRequested:
				let response = try await Network.shared.apollo.fetch(
					query: UserReviewRequestedMergeRequestsQuery(
						state: .none, search: .none, draft: .none, subscribed: .none),
					cachePolicy: .networkOnly)
				let mrs = response.data?.currentUser?.reviewRequestedMergeRequests?.nodes ?? []
				return .success(mrs.compactMap { $0 })
			}
		} catch let error {
			return .failure(error)
		}
	}

	private func loadMergeRequests() {
		loadTask?.cancel()
		loadTask = Task {
			let result = await loadFromCache()
			if !Task.isCancelled {
				self.mergeRequests = result
			}
		}
	}

	private func reloadMergeRequests() async {
		self.mergeRequests = await loadFromNetwork()
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
		.task {
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
