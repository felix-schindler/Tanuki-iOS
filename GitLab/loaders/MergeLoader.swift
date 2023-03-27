//
//  ProjectMergeLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct MergeLoader: View {
	/// Project ID
	@State var id: Int? = nil
	
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
				MergeListView(mergeRequests: mergeRequests!, updateFunction: getMRs, showRef: id == nil)
					.searchable(text: $search)
					.onSubmit(of: .search) {
						Task {
							mergeRequests = nil
							mergeRequests = await getMRs()
							loadFailed = (mergeRequests == nil)
						}
					}
					.toolbar {
						ToolbarItemGroup(placement: .navigationBarTrailing) {
							Button(action: {showFilter = true}) {
								Image(systemName: "line.3.horizontal.decrease.circle")
							}
						}
					}.sheet(isPresented: $showFilter) {
						List {
							Section {
								Picker("State", selection: $state) {
									Text("Open").tag(MergeState.opened)
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
		if (id != nil) {
			endpoint = "projects/\(id!)/merge_requests"
		}
		
		return await API.get(type: [MergeRequest].self, endpoint: endpoint, query: filter)
	}
}

struct MergeLoader_Previews: PreviewProvider {
	static var previews: some View {
		MergeLoader(id: nil)
	}
}
