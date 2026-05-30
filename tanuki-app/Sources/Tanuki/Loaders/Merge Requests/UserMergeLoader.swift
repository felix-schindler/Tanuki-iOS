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

	@State var mergeRequests: Result<[UserSmallMergeRequest], Error>? = nil

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
		Task {
			do {
				switch self.userRequestType {
				case .assgined:
					let mrs = try await Network.shared.service.fetchUserAssignedMergeRequests()
					self.mergeRequests = .success(mrs)
				case .authored:
					let mrs = try await Network.shared.service.fetchUserAuthoredMergeRequests()
					self.mergeRequests = .success(mrs)
				case .reviewRequested:
					let mrs = try await Network.shared.service.fetchUserReviewRequestedMergeRequests()
					self.mergeRequests = .success(mrs)
				}
			} catch let error {
				self.mergeRequests = .failure(error)
				Notify.status(.error)
			}
		}
	}

	private func reloadMergeRequests() async {
		do {
			switch self.userRequestType {
			case .assgined:
				let mrs = try await Network.shared.service.fetchUserAssignedMergeRequests()
				self.mergeRequests = .success(mrs)
			case .authored:
				let mrs = try await Network.shared.service.fetchUserAuthoredMergeRequests()
				self.mergeRequests = .success(mrs)
			case .reviewRequested:
				let mrs = try await Network.shared.service.fetchUserReviewRequestedMergeRequests()
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
			if let mergeRequests {
				switch mergeRequests {
				case .success(let mergeRequests):
					if mergeRequests.isEmpty {
						NoContentView("There are no merge requests", image: "git-mr.symbols")
					} else {
						ForEach(mergeRequests, id: \.reference) { mr in
							SmallMergeView(mr._project.fullPath, mr)
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
