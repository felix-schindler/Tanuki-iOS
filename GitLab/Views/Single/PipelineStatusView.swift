//
//  PipelineStatusView.swift
//  GitLab
//
//  Created by Felix Schindler on 02.11.21.
//

import SwiftUI

struct PiepelineStatusView: View {
    @State var pipeline: Pipeline
    @State var horizonzal: Bool = false

    var body: some View {
        if (horizonzal) {
            HStack {
                if (pipeline.status == "success") {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.green)
                    Text(pipeline.status.firstCapitalized)
                } else if (pipeline.status == "failed") {
                    Image(systemName: "minus.circle")
                        .foregroundColor(.red)
                    Text(pipeline.status.firstCapitalized)
                } else if (pipeline.status == "canceled") {
                    Image(systemName: "slash.circle")
                    Text(pipeline.status.firstCapitalized)
                } else {
                    Image(systemName: "arrow.2.circlepath.circle")
                        .foregroundColor(.orange)
                    Text(pipeline.status.firstCapitalized)
                }
            }
        } else {
            VStack {
                if (pipeline.status == "success") {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.green)
                    Text(pipeline.status.firstCapitalized)
                } else if (pipeline.status == "failed") {
                    Image(systemName: "minus.circle")
                        .foregroundColor(.red)
                    Text(pipeline.status.firstCapitalized)
                } else if (pipeline.status == "canceled") {
                    Image(systemName: "slash.circle")
                    Text(pipeline.status.firstCapitalized)
                } else {
                    Image(systemName: "arrow.2.circlepath.circle")
                        .foregroundColor(.orange)
                    Text(pipeline.status.firstCapitalized)
                }
            }
        }
    }
}

struct MergeView_Previews: PreviewProvider {
    static var previews: some View {
        PiepelineStatusView(pipeline: Pipeline())
    }
}
