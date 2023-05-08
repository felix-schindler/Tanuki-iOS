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
						NavigationLink(destination: IssuesLoader(id: id, state: (milestone.state == "active" ? IssueState.opened : IssueState.all), milestone: milestone.title)) {
							VStack(alignment: .leading) {
								Text(milestone.title.emojized())
									.fontWeight(.medium)
								if (milestone.description != "") {
									Markdown(milestone.description.emojized())
										.markdownTextStyle(textStyle: {
											ForegroundColor(.secondary)
										})
								}
								
								let showStartDate = (milestone.startDate != nil)
								let showDueDate = (milestone.dueDate != nil)
								
								if (showStartDate || showDueDate) {
									HStack {
										Image(systemName: "calendar.badge.clock")
										if (showStartDate) {
											Text(Date.fromToString(milestone.startDate!))
										}
										if (showStartDate && showDueDate) {
											Text("-")
										}
										if (showDueDate) {
											Text(Date.fromToString(milestone.dueDate!))
										}
									}
								}
							}
						}.swipeActions {
							AsyncButton(systemImage: "square.and.arrow.up") {
								await URL(string: milestone.webUrl)!.share()
							}
						}
					}
				}
			} else if (loadFailed) {
				Text("Failed to load, please check your internet connection and your token")
			} else {
				ProgressView()
			}
		}.refreshable {
			milestones = await getMilestones()
			loadFailed = (milestones == nil)
		}.searchable(text: $search)
			.onSubmit(of: .search) {
				Task {
					if let temp = await getMilestones() {
						milestones = temp
					}
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
			}.onAppear {
				Task {
					milestones = await getMilestones()
					loadFailed = (milestones == nil)
				}
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
		NavigationView {
			MilestoneLoader(id: 33025310)
		}
	}
}
