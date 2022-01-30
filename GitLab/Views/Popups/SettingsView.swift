//
//  SettingsView.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI
import MarkdownUI

struct SettingsView: View {
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    
    @State var url = ""
    @State var token = ""
    
    @State var showChangeConfig: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Button("Change GitLab configuration") {
                    showChangeConfig = true
                }
                Spacer()
                HStack {
                    Markdown("""
### About this project

Made with ❤️‍🔥 by [Felix Schindler](https://schindlerfelix.de)

I am just working on this app in my free time. I am a web developer and not a SwiftUI expert, so please forgive my mistakes. If there are any improvements you would like to contribute, report bugs or anything else please visit the [GitLab project](https://gitlab.com/felix-schindler/gitlab-ios).
""")
                    .multilineTextAlignment(.center)
                    .padding()
                }
                Spacer()
            }.sheet(isPresented: $showChangeConfig) {
                ChangeConfigView()
            }.navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button("Close", action: {self.presentationMode.wrappedValue.dismiss()}))
        }
    }
    
    private func validGitConfig() -> Bool {
        let oldUrl = API.base, oldToken = API.token
        
        API.base = url
        API.token = token
        
        do {
            let apiData: Data? = API.GET(endpoint: "user")
            if (apiData != nil) {
                var user: User
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                user = try decoder.decode(User.self, from: apiData!)
                print(user.name + " logged in")
                return true
            } else {
                API.base = oldUrl
                API.token = oldToken
                return false
            }
        } catch let jsonError as NSError {
            print("JSON error \(jsonError.localizedDescription)")
            API.base = oldUrl
            API.token = oldToken
            return false
        }
    }
}
