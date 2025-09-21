//
//  GroupMergeLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 05.03.24.
//

import GitLabAPI
import SwiftUI

struct GroupMergeLoader: View {
	private let fullPath: String

	@State
	private var mergeRequests: Result<[SmallMergeRequest?], Error>? = nil

	@State
	private var isLoading = false

	init(fullPath: String) {
		self.fullPath = fullPath
	}

	private func loadMergeRequests() {
		isLoading = true

		defer {
			isLoading = false
		}

		do {
			let responses = try Network.shared.apollo.fetch(
				query: GroupMergeRequestsQuery(fullPath: self.fullPath),
				cachePolicy: .cacheAndNetwork
			)

			Task {
				for try await response in responses {
					if let mrs = response.data?.group?.mergeRequests?.nodes {
						self.mergeRequests = .success(mrs)
					} else if let errors = response.errors {
						for error in errors {
							Notify.status(.error, error.localizedDescription)
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
			let response = try await Network.shared.apollo.fetch(
				query: GroupMergeRequestsQuery(fullPath: self.fullPath),
				cachePolicy: .networkOnly
			)

			if let mrs = response.data?.group?.mergeRequests?.nodes {
				self.mergeRequests = .success(mrs)
			}

			Notify.status(.success)
		} catch let error {
			self.mergeRequests = .failure(error)
			Notify.status(.error)
		}
	}

	public var body: some View {
		List {
			if isLoading {
				ProgressView("Loading merge requests")
			} else if let mergeRequests {
				switch mergeRequests {
				case .success(let mrs):
					if mrs.isEmpty {
						ContentUnavailableView("There are no merge requests", systemImage: "")
					} else {
						ForEach(mrs, id: \.?.reference) { maybeMerge in
							if let mr = maybeMerge {
								SmallMergeView(self.fullPath, mr)
							}
						}
					}
				case .failure(let error):
					FailedView(error)
				}
			}
		}.onAppear {
			loadMergeRequests()
		}.refreshable {
			await reloadMergeRequests()
		}.navigationTitle("Merge Requests")
	}
}

#Preview {
	NavigationStack {
		GroupMergeLoader(fullPath: "gitlab-org")
	}
}
