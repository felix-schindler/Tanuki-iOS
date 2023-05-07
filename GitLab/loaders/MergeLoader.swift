//
//  ProjectMergeLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct MergeLoader: View {
	/// Project ID
	@State var id = 0
	/// Group ID
	@State var groupId = 0
	
	@State var mergeRequests: [MergeRequest]? = nil
	@State var loadFailed: Bool = false
	
	@State var showFilter = false
	
	@State var search: String = ""
	
	// Filters
	@State var orderBy: MergeOrder = .createdAt
	@State var sort: IssueSort = .desc
	@State var state: MergeState = .opened
	
	var body: some View {
		VStack {
			if (mergeRequests != nil) {
				MergeListView(mergeRequests: mergeRequests!, updateFunction: getMRs, showRef: id == 0)
					.searchable(text: $search)
					.onSubmit(of: .search) {
						Task {
							mergeRequests = nil
							mergeRequests = await getMRs()
							loadFailed = (mergeRequests == nil)
						}
					}
					.toolbar {
						Button(action: {showFilter = true}) {
							Image(systemName: "line.3.horizontal.decrease.circle")
						}
					}.sheet(isPresented: $showFilter) {
						List {
							Section {
								Picker("State", selection: $state) {
									Text("Open").tag(MergeState.opened)
									Text("Closed").tag(MergeState.closed)
									Text("Merged").tag(MergeState.merged)
									Text("Locked").tag(MergeState.locked)
									Text("All").tag(MergeState.all)
								}
								
								Picker("Sort", selection: $sort) {
									Text("Ascending").tag(IssueSort.asc)
									Text("Descending").tag(IssueSort.desc)
								}
								
								Picker("Order by", selection: $orderBy) {
									Text("Title").tag(MergeOrder.title)
									Text("Created at").tag(MergeOrder.createdAt)
									Text("Updated at").tag(MergeOrder.updatedAt)
								}
							}
							
							AsyncButton("Apply") {
								mergeRequests = nil
								mergeRequests = await getMRs()
								loadFailed = (mergeRequests == nil)
								showFilter = false
							}
						}
					}
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
			Task {
				mergeRequests = await getMRs()
				loadFailed = (mergeRequests == nil)
			}
		}.navigationTitle("Merge requests")
	}
	
	private func getMRs() async -> [MergeRequest]? {
		var filter = ["with_labels_details": "true"]
		
		if (search != "") {
			filter["search"] = search
		}
		
		filter[MergeOrder.NAME.rawValue] = orderBy.rawValue
		filter[IssueSort.NAME.rawValue] = sort.rawValue
		filter[MergeState.NAME.rawValue] = state.rawValue
		
		var endpoint = "merge_requests"
		
		if (id != 0) {
			endpoint = "projects/\(id)/merge_requests"
		}
		
		if (groupId != 0) {
			endpoint = "groups/\(groupId)/merge_requests"
		}
		
		return await API.get(type: [MergeRequest].self, endpoint: endpoint, query: filter)
	}
}

struct MergeLoader_Previews: PreviewProvider {
	static var previews: some View {
		MergeLoader(id: 0)
	}
}
