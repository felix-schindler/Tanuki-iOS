//
//  ProjectMergeLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct ProjectMergeLoader: View {
	@State var id: Int
	@State var mergeRequests: [MergeRequest]? = nil
	@State var loadFailed: Bool = false
	
	var body: some View {
		VStack {
			if (mergeRequests != nil) {
				MergeListView(mergeRequests: mergeRequests!, updateFunction: getMRs)
			} else {
				if (loadFailed) {
					Text("Failed to load, please check your internet connection and your token")
				} else {
					VStack {
						Spacer()
						ProgressView("Loading")
						Spacer()
					}
				}
			}
		}.onAppear {
			Task.init {
				await getMRs()
			}
		}.navigationTitle("Merge requests")
	}
	
	private func getMRs() async -> Void {
		mergeRequests = await API.get(type: [MergeRequest].self, endpoint: "projects/\(id)/merge_requests", query: ["with_labels_details": "true"])
		loadFailed = (mergeRequests == nil)
	}
}

struct ProjectMergeLoader_Previews: PreviewProvider {
	static var previews: some View {
		ProjectMergeLoader(id: Int(0))
	}
}
