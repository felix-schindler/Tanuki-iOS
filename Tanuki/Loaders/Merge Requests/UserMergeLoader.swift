//
//  UserMergeLoader.swift
//  Tanuki
//
//  Created by Felix Schindler on 28.02.24.
//

import SwiftUI
import GitLabAPI


enum UserMergeRequestType {
	case assgined,
		 authored,
		 reviewRequested
}

struct UserMergeLoader: View {
	private var userRequestType: UserMergeRequestType
	private var navTitle: String
	
	@State
	private var mergeRequests: [UserSmallMergeRequest?]?
	
	@State
	private var loadFailed: Bool
	
	init(_ userRequestType: UserMergeRequestType) {
		self.userRequestType = userRequestType

		self.navTitle = switch self.userRequestType {
		case .assgined:
			"Assigned MRs"
		case .authored:
			"Authored MRs"
		case .reviewRequested:
			"Review requests MRs"
		}
		
		self.mergeRequests = nil
		self.loadFailed = false
	}
	
	private func loadMergeRequests() {
		switch self.userRequestType {
		case .assgined:
			Network.shared.apollo.fetch(query: UserAssignedMergeRequestsQuery()) { result in
				switch result {
				case .success(let graphQLResult):
					print("Success! Setting merge requests...")
					mergeRequests = graphQLResult.data?.currentUser?.assignedMergeRequests?.nodes as? [UserSmallMergeRequest?]
				case .failure(let error):
					print("Failure! Error: \(error)")
					loadFailed = true
				}
			}
			break
		case .authored:
			Network.shared.apollo.fetch(query: UserAuthoredMergeRequestsQuery()) { result in
				switch result {
				case .success(let graphQLResult):
					print("Success! Setting merge requests...")
					mergeRequests = graphQLResult.data?.currentUser?.authoredMergeRequests?.nodes as? [UserSmallMergeRequest?]
				case .failure(let error):
					print("Failure! Error: \(error)")
					loadFailed = true
				}
			}
			break
		case .reviewRequested:
			Network.shared.apollo.fetch(query: UserReviewRequestedMergeRequestsQuery()) { result in
				switch result {
				case .success(let graphQLResult):
					print("Success! Setting merge requests...")
					mergeRequests = graphQLResult.data?.currentUser?.reviewRequestedMergeRequests?.nodes as? [UserSmallMergeRequest?]
				case .failure(let error):
					print("Failure! Error: \(error)")
					loadFailed = true
				}
			}
			break
		}
	}
	
	public var body: some View {
		List {
			if (mergeRequests != nil) {
				if (mergeRequests!.isEmpty) {
					VStack(alignment: .center) {
						Image(systemName: "arrow.triangle.pull")
							.resizable()
							.scaledToFit()
							.frame(width: 50, height: 50)
						Text("There are no merge requests")
					}.frame(maxWidth: .infinity, minHeight: 100)
				} else {
					ForEach(mergeRequests!, id: \.self?.reference) { maybeMerge in
						if let mr = maybeMerge {
							SmallMergeView(mr._project.fullPath, mr)
						}
					}
				}
			} else {
				VStack(alignment: .center) {
					Image(systemName: "arrow.triangle.pull")
						.resizable()
						.scaledToFit()
						.frame(width: 50, height: 50)
					if loadFailed {
						Text(LOAD_FAILED)
					} else {
						ProgressView("Loading merge requests")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadMergeRequests()
		}.refreshable {
			loadMergeRequests()
		}.navigationTitle(self.navTitle)
	}
}
