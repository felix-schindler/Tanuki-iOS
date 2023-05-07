//
//  ProjectLabelsLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 19.03.23.
//

import SwiftUI

struct LabelsLoader: View {
	/// Project ID
	@State var id: Int
	/// Group ID
	@State var groupId: Int
	
	@State var labels: [APILabel]? = nil
	@State var loadFailed: Bool = false
	
	@State var showNewLabel: Bool = false
	@State var showEmpty: Bool
	
	init(id: Int = 0, groupId: Int = 0, showEmpty: Bool = false) {
		if (id == 0 && groupId == 0) {
			fatalError("Either project or group id has to be set!")
		}
		
		self.id = id
		self.groupId = groupId
		self.showEmpty = showEmpty
	}
	
	var body: some View {
		List {
			if (labels != nil) {
				LabelListView(labels: labels!, showDescription: true, showEmpty: showEmpty, projectId: id)
			} else if (loadFailed) {
				Text("Failed to load, please check your internet connection and your token")
			} else {
				ProgressView()
			}
		}.refreshable {
			labels = nil
			labels = await getLabels()
			loadFailed = (labels == nil)
		}.onAppear {
			Task {
				labels = await getLabels()
				loadFailed = (labels == nil)
			}
		}.toolbar {
			Button (action: { showNewLabel = true }) {
				Image(systemName: "plus.circle")
			}
		}.sheet(isPresented: $showNewLabel) {
			NewLabelView(id: id, groupId: groupId)
		}.navigationTitle("Labels")
	}
	
	private func getLabels() async -> [APILabel]? {
		let endpoint: String = (id != 0 ? "projects/\(id)/labels" : "groups/\(groupId)/labels")
		return await API.get(type: [APILabel].self, endpoint: endpoint)
	}
}

struct LabelsLoader_Previews: PreviewProvider {
	static var previews: some View {
		LabelsLoader(id: 33025310)
	}
}
