//
//  FileView.swift
//  GitLab
//
//  Created by Felix Schindler on 23.01.22.
//

import SwiftUI
import MarkdownUI

struct FileView: View {
    @State var fileName: String
    @State var content: String

    var body: some View {
        VStack {
            ScrollView {
                if (fileName.lowercased().contains(".md")) {
                    Markdown(content)
                        .markdownTheme(.gitHub)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text(content)
                        .font(.system(.body, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            Spacer()
        }
    }
}

struct FileView_Previews: PreviewProvider {
    static var previews: some View {
        FileView(fileName: "", content: "")
    }
}
