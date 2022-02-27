//
//  ChangeConfigView.swift
//  GitLab
//
//  Created by Felix Schindler on 02.11.21.
//

import SwiftUI
import MarkdownUI

/// This View is meant to be used as a sheet.
/// Lets the user change the GitLab configuration (URL, Token)
struct ChangeConfigView: View {
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    
    @State var url: String = API.domain     // New GitLab URL
    @State var token: String = API.token    // New GitLab Token
    
    @State var swipeError: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("GitLab URL")
                    .font(.headline)
                TextField("https://gitlab.com", text: $url)
                    .padding()
                    .textContentType(.URL)
                    .keyboardType(.URL)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                Text("Personal Access Token")
                    .font(.headline)
                TextField("glpat-4Rzq-VKwapmWqj4MfBsi", text: $token)
                    .padding()
                    .disableAutocorrection(true)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                Markdown("""
### Minimum permission level
- [x] api
- [x] read_user
- [x] read_api
- [x] read_repository

The required API version is v4.
""").foregroundColor(.secondary)
                Spacer()
                Button(action: {
                    swipeError = !validGitConfig()
                    if (!swipeError) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Text("Save configuration").frame(maxWidth: .infinity)
                }).alert(isPresented: $swipeError, content: {
                    Alert(title: Text("Error"), message: Text("Invalid configuration, please check the entered url and token"), dismissButton: .default(Text("OK")))
                }).tint(.accentColor)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle)
                .controlSize(.large)
            }.padding()
            .navigationBarTitle("Change GitLab config")
            .navigationBarItems(trailing: Button("Cancel", action: {self.presentationMode.wrappedValue.dismiss()}).foregroundColor(.red))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func validGitConfig() -> Bool {
        let oldUrl = API.base, oldToken = API.token
        
        API.domain = url
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

struct ChangeConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeConfigView()
    }
}
