//
//  FileLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 02.11.21.
//

import SwiftUI
// import MarkdownUI

struct FileLoader: View {
    @State var file: File? = nil
    @State var noConnection: Bool = false
    @State var showNotFound: Bool = false
    
    @State var id: Int
    @State var filePath: String
    @State var refName: String
    
    @State var inline: Bool = false

    var body: some View {
        VStack {
            if (file != nil) {
                let content: String? = file!.content.fromBase64()?.emojized()
                if (content != nil) {
                    if (inline) {
                        Text(file!.filePath)
                            .font(.headline)
                        if (filePath.lowercased().contains(".md")) {
                            // Markdown(content!)
                            Text(content!)
                                .font(.system(.body, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Text(content!)
                                .font(.system(.body, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    } else {
                        FileView(fileName: file!.filePath, content: content!)
                    }
                }
            } else {
                if (showNotFound) {
                    if (noConnection) {
                        Text("Failed to load, please check your internet connection and your token")
                    } else {
                        VStack {
                            Spacer()
                            ProgressView("Loading")
                            Spacer()
                        }
                    }
                }
            }
        }.onAppear {
            Task.init {
                await getFile()
            }
        }.padding()
    }
    
    private func getFile() async -> Void {
        file = await API.get(type: File.self, endpoint: "projects/\(id)/repository/files/\(filePath.url())", query: ["ref": refName.url()])
        noConnection = file == nil
    }
}

struct FileLoader_Previews: PreviewProvider {
    static var previews: some View {
        FileLoader(id: Int(), filePath: String(), refName: String())
    }
}
