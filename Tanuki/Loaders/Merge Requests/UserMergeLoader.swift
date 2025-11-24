//
//  UserMergeLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 28.02.24.
//

import GitLabAPI
import SwiftUI

enum UserMergeRequestType {
	case assgined,
		authored,
		reviewRequested
}

struct UserMergeLoader: View {
	private var userRequestType: UserMergeRequestType
	private var navTitle: String

	@State
	private var mergeRequests: Result<[UserSmallMergeRequest?], Error>? = nil

	init(_ userRequestType: UserMergeRequestType) {
		self.userRequestType = userRequestType

		self.navTitle =
			switch self.userRequestType {
			case .assgined:
				"Assigned MRs"
			case .authored:
				"Authored MRs"
			case .reviewRequested:
				"Review requests MRs"
			}
	}

	private func loadMergeRequests() {
		do {
			switch self.userRequestType {
			case .assgined:
				let responses = try Network.shared.apollo.fetch(
					query: UserAssignedMergeRequestsQuery(),
					cachePolicy: .cacheAndNetwork
				)

				Task {
					for try await response in responses {
						if let mrs = response.data?.currentUser?.assignedMergeRequests?.nodes {
							self.mergeRequests = .success(mrs)
						} else if let errors = response.errors {
							for error in errors {
								Notify.status(.error, error.localizedDescription)
							}
						}
					}
				}
			case .authored:
				let responses = try Network.shared.apollo.fetch(
					query: UserAuthoredMergeRequestsQuery(),
					cachePolicy: .cacheAndNetwork
				)

				Task {
					for try await response in responses {
						if let mrs = response.data?.currentUser?.authoredMergeRequests?.nodes {
							self.mergeRequests = .success(mrs)
						} else if let errors = response.errors {
							for error in errors {
								Notify.status(.error, error.localizedDescription)
							}
						}
					}
				}
			case .reviewRequested:
				let responses = try Network.shared.apollo.fetch(
					query: UserReviewRequestedMergeRequestsQuery(),
					cachePolicy: .cacheAndNetwork
				)

				Task {
					for try await response in responses {
						if let mrs = response.data?.currentUser?.reviewRequestedMergeRequests?.nodes {
							self.mergeRequests = .success(mrs)
						} else if let errors = response.errors {
							for error in errors {
								Notify.status(.error, error.localizedDescription)
							}
						}
					}
				}
			}
		} catch let error {
			self.mergeRequests = .failure(error)
			Notify.status(.error)
		}
	}

	private func reloadMergeRequests() async {
		do {
			switch self.userRequestType {
			case .assgined:
				let response = try await Network.shared.apollo.fetch(
					query: UserAssignedMergeRequestsQuery(),
					cachePolicy: .networkOnly
				)

				if let mrs = response.data?.currentUser?.assignedMergeRequests?.nodes {
					self.mergeRequests = .success(mrs)
				}
			case .authored:
				let response = try await Network.shared.apollo.fetch(
					query: UserAuthoredMergeRequestsQuery(),
					cachePolicy: .networkOnly
				)

				if let mrs = response.data?.currentUser?.authoredMergeRequests?.nodes {
					self.mergeRequests = .success(mrs)
				}
			case .reviewRequested:
				let response = try await Network.shared.apollo.fetch(
					query: UserReviewRequestedMergeRequestsQuery(),
					cachePolicy: .networkOnly
				)

				if let mrs = response.data?.currentUser?.reviewRequestedMergeRequests?.nodes {
					self.mergeRequests = .success(mrs)
				}
			}

			Notify.status(.success)
		} catch let error {
			self.mergeRequests = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if let mergeRequests {
				switch mergeRequests {
				case .success(let mergeRequests):
					if mergeRequests.isEmpty {
						NoContentView("There are no merge requests", image: "git-mr.symbols")
					} else {
						ForEach(mergeRequests, id: \.?.reference) {
							maybeMerge in
							if let mr = maybeMerge {
								SmallMergeView(mr._project.fullPath, mr)
							}
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading Merge Requests", image: "git-mr.symbols", color: .blue)
			}
		}.onAppear {
			loadMergeRequests()
		}.refreshable {
			await reloadMergeRequests()
		}.navigationTitle(self.navTitle)
	}
}

#Preview {
	NavigationView {
		UserMergeLoader(.authored)
	}
}
