//
//  MergeRequestsView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct PipelineListView: View {
	@State var pipelines: [Pipeline]
	@State var updateFunction: () async -> [Pipeline]?
	
	var body: some View {
		List(pipelines, id: \.id) { pipeline in
			HStack {
				VStack(alignment: .leading) {
					Text(pipeline.ref)
						.fontWeight(.medium)
					Text("\(pipeline.source) · \(pipeline.createdAt.toShortString())")
						.font(.footnote)
				}
				Spacer()
				HStack {
					Text(pipeline.status.firstCapitalized)
						.foregroundColor(.secondary)
						.font(.caption)
                    PipelineStatusView(status: pipeline.status)
				}
			}
		}.refreshable {
			if let temp = await updateFunction() {
				pipelines = temp
			}
		}.navigationTitle("Pipelines")
	}
}

struct PipelineListView_Previews: PreviewProvider {
	static var previews: some View {
		PipelineListView(pipelines: [
			Pipeline(id: 1, ref: "main", status: "success", source: "some-source", createdAt: Date()),
			Pipeline(id: 1, ref: "main", status: "success", source: "some-source", createdAt: Date()),
			Pipeline(id: 1, ref: "main", status: "success", source: "some-source", createdAt: Date())
		], updateFunction: { nil })
	}
}
