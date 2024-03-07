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
	private var mergeRequests: [SmallMergeRequest?]? = nil

	@State
	private var loadFailed = false

	init(fullPath: String) {
		self.fullPath = fullPath
	}

	private func loadMergeRequests() {
		Network.shared.apollo.fetch(query: GroupMergeRequestsQuery(fullPath: self.fullPath)) {
			result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting merge requests...")
				mergeRequests = graphQLResult.data?.group?.mergeRequests?.nodes
			case .failure(let error):
				print("Failure! Error: \(error)")
				loadFailed = true
			}
		}
	}

	var body: some View {
		List {
			if let mergeRequests = self.mergeRequests {
				if mergeRequests.isEmpty {
					Text("There are no merge requests")
				} else {
					ForEach(mergeRequests, id: \.?.reference) { maybeMerge in
						if let mr = maybeMerge {
							SmallMergeView(self.fullPath, mr)
						}
					}
				}
			} else {
				VStack {
					if loadFailed {
						Text(loadFailedMsg)
					} else {
						ProgressView("Loading merge requests")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
			}
		}.onAppear {
			loadMergeRequests()
		}.refreshable {
			loadMergeRequests()
		}.navigationTitle("Merge Requests")
	}
}

#Preview {
	NavigationStack {
		GroupMergeLoader(fullPath: "gitlab-org")
	}
}
