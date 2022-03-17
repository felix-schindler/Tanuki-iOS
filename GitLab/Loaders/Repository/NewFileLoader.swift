//
//  NewFileLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 27.02.22.
//

import SwiftUI
// import MarkdownUI

struct NewFileLoader: View {
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
                            MarkdownLoader(content: content!, project: refName)
                        } else {
                            Text(content!)
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
        do {
            let apiData: Data? = API.GET(endpoint: "projects/\(id)/repository/files/\(filePath.url())?ref=\(refName.url())")
            if (apiData != nil) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                file = try decoder.decode(File.self, from: apiData!)
            } else {
                noConnection = true
            }
        } catch let jsonError as NSError {
            print("JSON error \(jsonError.localizedDescription)")
        }
    }
}
