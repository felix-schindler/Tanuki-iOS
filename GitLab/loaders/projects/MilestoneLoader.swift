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
	
	@State var milestones: [Milestone]?
	@State var loadFailed: Bool = false
	
	/// Search
	@State var search: String = ""
	
	/// Filter
	@State var showFilter: Bool = false
	@State var state: MilestoneState = .active
	
	var body: some View {
		List {
			if (milestones != nil) {
				ForEach(milestones!, id: \.id) { milestone in
					NavigationLink(destination: MilestoneView(milestone: milestone)) {
						VStack(alignment: .leading) {
							Text(milestone.title.emojized())
								.fontWeight(.medium)
							if (milestone.description != "") {
								Markdown(milestone.description.emojized())
									.markdownTextStyle(textStyle: {
										ForegroundColor(.secondary)
									})
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
				
			}.toolbar {
				Button(action: { showFilter = true }) {
					Image(systemName: "line.3.horizontal.decrease.circle")
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
					
					AsyncButton(action: {
						milestones = nil
						let temp = await getMilestones()
						if (temp != nil) {
							milestones = temp
						}
						showFilter = false
					}, label: {
						Text("Apply")
					})
				}
			}.onAppear {
				Task.init {
					milestones = await getMilestones()
					loadFailed = (milestones == nil)
				}
			}.navigationTitle("Milestones")
	}
	
	private func getMilestones() async -> [Milestone]? {
		var filter: Dictionary<String, String> = [:]
		
		if (!search.isEmpty) {
			filter["search"] = search
		}
		
		if (state != .all) {
			filter[MilestoneState.NAME.rawValue] = state.rawValue
		}
		
		return await API.get(type: [Milestone].self, endpoint: "projects/\(id)/milestones", query: filter)
	}
}

struct MilestoneLoader_Previews: PreviewProvider {
	static var previews: some View {
		MilestoneLoader(id: 33025310)
	}
}
