//
//  MergeRequestsView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct PipelineListView: View {
	@State var pipelines: [Pipeline]
	@State var updateFunction: () async -> Void
	
	var body: some View {
		VStack {
			List(pipelines, id: \.id) { pipeline in
				HStack {
					VStack {
						Text(pipeline.ref)
							.frame(maxWidth: .infinity, alignment: .leading)
						Text("\(pipeline.source) · \(pipeline.createdAt.toString())")
							.font(.footnote)
							.foregroundColor(.secondary)
							.frame(maxWidth: .infinity, alignment: .leading)
					}
					Spacer()
					HStack {
						Text(pipeline.status.firstCapitalized)
							.foregroundColor(.secondary)
							.font(.footnote)
						PipelineStatusView(pipeline: pipeline)
					}
				}
			}.refreshable {
				await updateFunction()
			}
		}.navigationTitle("Pipelines")
	}
}

struct PipelineListView_Previews: PreviewProvider {
	static var previews: some View {
		PipelineListView(pipelines: [Pipeline](), updateFunction: {})
	}
}
