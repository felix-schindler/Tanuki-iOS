#if os(watchOS)
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

		// The watch has no filter UI, so every variable stays null (= no
		// filtering) while the query itself now requires them.
		private func assignedQuery() -> UserAssignedMergeRequestsQuery {
			UserAssignedMergeRequestsQuery(
				state: nil,
				search: nil,
				draft: nil,
				subscribed: nil
			)
		}

		private func authoredQuery() -> UserAuthoredMergeRequestsQuery {
			UserAuthoredMergeRequestsQuery(
				state: nil,
				search: nil,
				draft: nil,
				subscribed: nil
			)
		}

		private func reviewRequestedQuery() -> UserReviewRequestedMergeRequestsQuery {
			UserReviewRequestedMergeRequestsQuery(
				state: nil,
				search: nil,
				draft: nil,
				subscribed: nil
			)
		}

		private func loadMergeRequests() {
			do {
				switch self.userRequestType {
				case .assigned:
					let responses = try Network.shared.apollo.fetch(
						query: self.assignedQuery(),
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
						query: self.authoredQuery(),
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
						query: self.reviewRequestedQuery(),
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
						query: self.assignedQuery(),
						cachePolicy: .networkOnly
					)

					if let mrs = response.data?.currentUser?.assignedMergeRequests?.nodes {
						let mapped: [any SmallMergeRequest] = mrs.compactMap { $0 }
						self.mergeRequests = .success(mapped)
					}
				case .authored:
					let response = try await Network.shared.apollo.fetch(
						query: self.authoredQuery(),
						cachePolicy: .networkOnly
					)

					if let mrs = response.data?.currentUser?.authoredMergeRequests?.nodes {
						let mapped: [any SmallMergeRequest] = mrs.compactMap { $0 }
						self.mergeRequests = .success(mapped)
					}
				case .reviewRequested:
					let response = try await Network.shared.apollo.fetch(
						query: self.reviewRequestedQuery(),
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
		NavigationStack {
			UserMergeLoader(.authored)
		}
	}
#endif
