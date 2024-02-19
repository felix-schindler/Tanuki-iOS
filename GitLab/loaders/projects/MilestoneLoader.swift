//
//  MilestoneLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 26.03.23.
//

import SwiftUI
import MarkdownUI

struct MilestoneLoader: View {
	/// Project ID
	@State var id: Int
	/// Group ID
	@State var groupId: Int
	
	@State var milestones: [Milestone]?
	@State var loadFailed: Bool = false
	
	/// Search
	@State var search: String = ""
	
	/// Filter
	@State var showFilter: Bool = false
	@State var state: MilestoneState = .active
	
	@State var showNewMilestone = false
	
	init(id: Int = 0, groupId: Int = 0) {
		if (id == 0 && groupId == 0) {
			fatalError("Either project or group id has to be set!")
		}
		
		self.id = id
		self.groupId = groupId
	}
	
	var body: some View {
		List {
			if (milestones != nil) {
				if (milestones!.isEmpty) {
					Text("There are no milestones")
				} else {
					ForEach(milestones!, id: \.id) { milestone in
						MilestoneView(id: id, milestone: milestone)
					}
				}
			} else if (loadFailed) {
				Text(Messages.failedToLoad)
			} else {
				ProgressView()
			}
		}.refreshable {
			milestones = await getMilestones()
			loadFailed = (milestones == nil)
		}.onAppear {
			Task {
				milestones = await getMilestones()
				loadFailed = (milestones == nil)
			}
		}.searchable(text: $search)
			.onSubmit(of: .search) {
				Task {
					milestones = await getMilestones()
					loadFailed = (milestones == nil)
				}
			}.toolbar {
				Button(action: { showFilter = true }) {
					Image(systemName: "line.3.horizontal.decrease.circle")
				}
				Button(action: { showNewMilestone = true }) {
					Image(systemName: "plus.circle")
				}
			}.sheet(isPresented: $showFilter) {
				List {
					Section {
						Picker("State", selection: $state) {
							Text("Active").tag(MilestoneState.active)
							Text("Closed").tag(MilestoneState.closed)
							Text("All").tag(MilestoneState.all)
						}
					}
					
					AsyncButton("Apply") {
						milestones = nil
						if let temp = await getMilestones() {
							milestones = temp
						}
						showFilter = false
					}
				}
			}.sheet(isPresented: $showNewMilestone) {
				NewMilestone(id: id, groupId: groupId)
			}.navigationTitle("Milestones")
	}
	
	private func getMilestones() async -> [Milestone]? {
		let endpoint: String = (id != 0 ? "projects/\(id)/milestones" : "groups/\(groupId)/milestones")
		var filter: Dictionary<String, String> = [:]
		
		if (!search.isEmpty) {
			filter["search"] = search
		}
		
		if (state != .all) {
			filter[MilestoneState.NAME.rawValue] = state.rawValue
		}
		
		return await API.get(type: [Milestone].self, endpoint: endpoint, query: filter)
	}
}

struct MilestoneLoader_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			MilestoneLoader(id: 33025310)
		}
	}
}
