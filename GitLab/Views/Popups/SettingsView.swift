//
//  SettingsView.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

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
                Button(action: {showChangeConfig = true}) {
                    Text("Change GitLab configuration")
                }
                Spacer()
                HStack {
                    Text("Made with ❤️‍🔥 by")
                    Link("Felix Schindler", destination: URL(string: "https://schindlerfelix.de")!)
                }
                Link("Find this App on GitLab", destination: URL(string: "https://gitlab.com/felix-schindler/gitlab_ios")!)
                Spacer()
            }.sheet(isPresented: $showChangeConfig) {
                ChangeConfigView()
            }
            .navigationBarTitle("Settings")
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
