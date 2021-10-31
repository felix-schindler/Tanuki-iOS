//
//  AboutView.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            Spacer()
            Text("Made with ❤️‍🔥 by")
            Link("Felix Schindler", destination: URL(string: "https://schindlerfelix.de")!)
            Spacer()
            Link("Find this App on GitHub", destination: URL(string: "https://github.com/felix-schindler/gitlab_ios")!)
            Spacer()
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
