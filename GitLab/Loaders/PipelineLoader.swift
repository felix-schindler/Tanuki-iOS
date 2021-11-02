//
//  PipelineLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 02.11.21.
//

import SwiftUI

struct PipelineLoader: View {
    @State var pipelines: [Pipeline]? = nil

    @State var id: Int
    @State var branch: String = ""

    @State var statusHorizontal: Bool = false
    @State var onlyStatus: Bool = true
    @State var showStatusStr: Bool = false

    var body: some View {
        VStack {
            if (pipelines != nil) {
                if (onlyStatus) {
                    if (!pipelines!.isEmpty) {
                        PipelineStatusView(pipeline: pipelines![0], horizontal: statusHorizontal, showStatus: showStatusStr)
                    }
                } else {
                    PipelineListView(pipelines: pipelines!, updateFunction: getPipeline)
                }
            }
        }.onAppear {
            Task.init {
                await getPipeline()
            }
        }.padding()
    }

    private func getPipeline() async -> Void {
        do {
            let apiData: Data? = API.GET(endpoint: "projects/" + String(id) + "/pipelines?ref=" + branch)
            if (apiData != nil) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                pipelines = try decoder.decode([Pipeline].self, from: apiData!)
            }
        } catch let jsonError as NSError {
            print("JSON error \(jsonError.localizedDescription)")
        }
    }
}

struct PipelineLoader_Previews: PreviewProvider {
    static var previews: some View {
        PipelineLoader(id: Int(), branch: String(), statusHorizontal: Bool())
    }
}
