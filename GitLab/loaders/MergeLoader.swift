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
	@State var sort: ProjectSort = .desc
	@State var state: MergeState = .opened
	
	var body: some View {
		List {
			if (mergeRequests != nil) {
				if (mergeRequests!.isEmpty) {
					Text("You're all caught up, there are no merge requests! 🥳")
				} else {
					ForEach(mergeRequests!, id: \.id) { mr in
						SmallMergeView(mr: mr, showRef: (id == 0))
					}
				}
			} else {
				if (loadFailed) {
					Text(Messages.failedToLoad)
				} else {
					ProgressView()
				}
			}
		}.refreshable {
			if let temp = await getMRs() {
				mergeRequests = temp
			} else {
				loadFailed = true
			}
		}.onAppear {
			Task {
				mergeRequests = await getMRs()
				loadFailed = (mergeRequests == nil)
			}
		}.searchable(text: $search)
			.onSubmit(of: .search) {
				Task {
					mergeRequests = nil
					mergeRequests = await getMRs()
					loadFailed = (mergeRequests == nil)
				}
			}
			.toolbar {
				RoundIconButton("Show Filters", icon: "line.3.horizontal.decrease") {
					showFilter = true
				}
			}.sheet(isPresented: $showFilter) {
				VStack {
					Form {
						Section {
							Picker("State", selection: $state) {
								Label("Open", systemImage: "arrow.triangle.pull")
									.tag(MergeState.opened)
								Label("Closed", systemImage: "minus.circle")
									.tag(MergeState.closed)
								Label("Merged", systemImage: "arrow.triangle.merge")
									.tag(MergeState.merged)
								Label("Locked", systemImage: "lock")
									.tag(MergeState.locked)
								Label("All", systemImage: "")
									.tag(MergeState.all)
							}
							
							Picker("Sort", selection: $sort) {
								Label("Ascending", systemImage: "increase.indent")
									.tag(ProjectSort.asc)
								Label("Descending", systemImage: "decrease.indent")
									.tag(ProjectSort.desc)
							}
							
							Picker("Order by", selection: $orderBy) {
								Label("Title", systemImage: "number")
									.tag(MergeOrder.title)
								Label("Created at", systemImage: "doc.badge.plus")
									.tag(MergeOrder.createdAt)
								Label("Updated at", systemImage: "doc.badge.clock")
									.tag(MergeOrder.updatedAt)
							}
						}.presentationDetents([.large, .medium])
					}
					
					VStack {
						AsyncButton(action: {
							mergeRequests = nil
							mergeRequests = await getMRs()
							loadFailed = (mergeRequests == nil)
							showFilter = false
						}, label: {
							Text("Apply")
								.frame(maxWidth: .infinity)
						}).controlSize(.large)
							.buttonStyle(.bordered)
						
						Button(role: .cancel,
							   action: {
							showFilter = false
						}, label: {
							Text("Cancel")
								.frame(maxWidth: .infinity)
						}).foregroundStyle(.secondary)
							.buttonStyle(.bordered)
							.controlSize(.large)
					}.padding()
				}
			}.navigationTitle("Merge requests")
	}
	
	private func getMRs() async -> [MergeRequest]? {
		// var filter = ["with_labels_details": "true"]
		var filter: Dictionary<String, String> = [:]
		
		if (search != "") {
			filter["search"] = search
		}
		
		filter[MergeOrder.NAME.rawValue] = orderBy.rawValue
		filter[ProjectSort.NAME.rawValue] = sort.rawValue
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
		NavigationStack {
			MergeLoader(id: 33025310)
		}
	}
}
