//
//  ProjectLabelsLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 19.03.23.
//

import SwiftUI

struct ProjectLabelsLoader: View {
	/// Project ID
	@State var id: Int
	
	@State var labels: [APILabel]? = nil
	@State var loadFailed: Bool = false
	
	@State var showNewLabel: Bool = false
	
	var body: some View {
		List {
			if (labels != nil) {
				LabelListView(labels: labels!, showDescription: true, projectId: id)
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
			ToolbarItemGroup(placement: .navigationBarTrailing) {
				Button (action: { showNewLabel = true }) {
					Image(systemName: "plus.circle")
				}
			}
		}.sheet(isPresented: $showNewLabel) {
			NewLabelView(id: id)
		}.navigationTitle("Labels")
	}
	
	private func getLabels() async -> [APILabel]? {
		return await API.get(type: [APILabel].self, endpoint: "projects/\(id)/labels")
	}
}

struct ProjectLabelsLoader_Previews: PreviewProvider {
	static var previews: some View {
		ProjectLabelsLoader(id: 33025310)
	}
}
