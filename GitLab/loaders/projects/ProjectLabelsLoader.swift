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
	
	var body: some View {
		VStack {
			if (labels != nil) {
				LabelsView(labels: labels!, updateFunction: getLabels)
			} else if (loadFailed) {
				Text("Failed to load, please check your internet connection and your token")
			} else {
				Spacer()
				ProgressView("Loading")
				Spacer()
			}
		}.onAppear {
			Task.init {
				labels = await getLabels()
				loadFailed = (labels == nil)
			}
		}
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
