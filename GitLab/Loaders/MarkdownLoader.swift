//
//  MarkdownLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 17.03.22.
//

import SwiftUI

struct MarkdownLoader: View {
    @State var htmlStr: String? = nil

    @State var content: String
    @State var project: String
    @State var mode: String = "gfm"

    var body: some View {
        VStack {
            if (htmlStr != nil) {
                HTMLView(htmlString: htmlStr!)
            } else {
                ProgressView()
            }
        }.onAppear {
            Task.init {
                await loadMarkdown()
            }
        }
    }
    
    private func loadMarkdown() async -> Void {
        do {
            let apiData: Data? = API.POST(endpoint: "markdown", values: [
                "text": content,
                "mode": mode,
                "project": project
            ])
            if (apiData != nil) {
                let decoder = JSONDecoder()
                let temp = try decoder.decode(MarkdownHTML.self, from: apiData!)
                htmlStr = temp.html
            }
        } catch let jsonError as NSError {
            print("JSON error \(jsonError.localizedDescription)")
        }
    }
}

struct MarkdownLoader_Previews: PreviewProvider {
    static var previews: some View {
        MarkdownLoader(htmlStr: "", content: "", project: "", mode: "")
    }
}
