//
//  PipelineStatusView.swift
//  GitLab
//
//  Created by Felix Schindler on 02.11.21.
//

import SwiftUI

struct PipelineStatusView: View {
    @State var pipeline: Pipeline
    @State var horizontal: Bool = false
    @State var showStatus: Bool = false
    
    var body: some View {
        if (horizontal) {
            HStack {
                if (pipeline.status == "success") {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.green)
                } else if (pipeline.status == "failed") {
                    Image(systemName: "minus.circle")
                        .foregroundColor(.red)
                } else if (pipeline.status == "canceled") {
                    Image(systemName: "slash.circle")
                } else {
                    Image(systemName: "arrow.2.circlepath.circle")
                        .foregroundColor(.orange)
                }
                if (showStatus) {
                    Text(pipeline.status.firstCapitalized)
                }
            }
        } else {
            VStack {
                if (pipeline.status == "success") {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.green)
                } else if (pipeline.status == "failed") {
                    Image(systemName: "minus.circle")
                        .foregroundColor(.red)
                } else if (pipeline.status == "canceled") {
                    Image(systemName: "slash.circle")
                } else {
                    Image(systemName: "arrow.2.circlepath.circle")
                        .foregroundColor(.orange)
                }
                if (showStatus) {
                    Text(pipeline.status.firstCapitalized)
                }
            }
        }
    }
}

struct PipelineStatusView_Previews: PreviewProvider {
    static var previews: some View {
        PipelineStatusView(pipeline: Pipeline(id: Int(), ref: String(), status: String()))
    }
}
