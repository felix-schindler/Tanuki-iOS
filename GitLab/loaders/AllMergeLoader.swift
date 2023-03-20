//
//  AllMergeLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct AllMergeLoader: View {
	@State var mergeRequests: [MergeRequest]? = nil
	@State var noConnection: Bool = false
	
	var body: some View {
		VStack {
			if (mergeRequests != nil) {
				MergeListView(mergeRequests: mergeRequests!, updateFunction: getMRs, showRef: true)
			} else {
				if (noConnection) {
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
				mergeRequests = await getMRs()
				noConnection = mergeRequests == nil
			}
		}.navigationTitle("Merge requests")
	}
	
	private func getMRs() async -> [MergeRequest]? {
		return await API.get(type: [MergeRequest].self, endpoint: "merge_requests", query: ["state": "opened"])
	}
}

struct AllMergeLoader_Previews: PreviewProvider {
	static var previews: some View {
		AllMergeLoader()
	}
}
