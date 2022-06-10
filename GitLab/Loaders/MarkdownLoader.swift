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
        let temp = await API.req(type: MarkdownHTML.self, method: .post, endpoint: "markdown", body: [
            "text": content,
            "mode": mode,
            "project": project
        ])
        
        if (temp != nil) {
            htmlStr = temp!.html
        }
    }
}

struct MarkdownLoader_Previews: PreviewProvider {
    static var previews: some View {
        MarkdownLoader(htmlStr: "", content: "", project: "", mode: "")
    }
}
