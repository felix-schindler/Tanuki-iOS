//
//  PipelineLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 02.11.21.
//

import SwiftUI

struct PipelineLoader: View {
	@State var pipelines: [Pipeline]? = nil
	@State var loadFailed: Bool = false
	
	@State var id: Int
	@State var branch: String = ""
	
	@State var onlyStatus: Bool = true
	
	var body: some View {
		VStack {
			if (pipelines == nil) {
				if (onlyStatus) {
					EmptyView()
				} else if (loadFailed) {
					Text("Failed to load, please check your internet connection and your token")
				} else {
					ProgressView()
				}
			} else {
				if (onlyStatus) {
					if (pipelines!.isEmpty) {
						EmptyView()
					} else {
                        PipelineStatusView(status: pipelines![0].status)
					}
				} else {
					if (pipelines!.isEmpty) {
						Text("To get startet with pipelines, create a .gitlab-ci.yml file")
					} else {
						PipelineListView(pipelines: pipelines!, updateFunction: getPipeline)
					}
				}
			}
		}.onAppear {
			Task {
				pipelines = await getPipeline()
				loadFailed = (pipelines == nil)
			}
		}
	}
	
	private func getPipeline() async -> [Pipeline]? {
		var filter: Dictionary<String, String> = [:]
		if (branch != "") {
			filter["ref"] = branch
		}
		
		return await API.get(type: [Pipeline].self, endpoint: "projects/\(id)/pipelines", query: filter)
	}
}

struct PipelineLoader_Previews: PreviewProvider {
	static var previews: some View {
		PipelineLoader(id: 42346328, branch: "main", onlyStatus: false)
	}
}
