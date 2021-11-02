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
        if (pipelines.isEmpty) {
            Text("No pipelines")
        } else {
            List(pipelines, id: \.id) { pipeline in
                HStack {
                    Text(pipeline.ref)
                    Spacer()
                    PipelineStatusView(pipeline: pipeline)
                }
            }.refreshable {
                await updateFunction()
            }
        }
    }
}

struct PipelineListView_Previews: PreviewProvider {
    static var previews: some View {
        PipelineListView(pipelines: [Pipeline](), updateFunction: {})
    }
}
