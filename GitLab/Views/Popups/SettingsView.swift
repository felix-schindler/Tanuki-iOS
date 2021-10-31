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
    
    @State var isError: Bool = false
    @State var showAbout: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                VStack {
                    Text("Change GitLab server")
                        .font(.title)
                    TextField("New GitLab URL", text: $url)
                        .padding()
                        .textContentType(.URL)
                        .keyboardType(.URL)
                        .background(Color(.systemGray5))
                        .cornerRadius(10)
                    TextField("New GitLab Token", text: $token)
                        .padding()
                        .disableAutocorrection(true)
                        .background(Color(.systemGray5))
                        .cornerRadius(10)
                    Button(action: {
                        isError = !validGitConfig()
                    }, label: {
                        Text("Save configuration").frame(maxWidth: .infinity)
                    }).alert(isPresented: $isError, content: {
                        Alert(title: Text("Error"), message: Text("Invalid configuration, check the entered url and token"), dismissButton: .default(Text("OK")))
                    }).tint(.accentColor)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle)
                    .controlSize(.large)
                }.padding()
                Spacer()
                Button (action: {showAbout = true}) {
                    Text("About this app")
                }
                Spacer()
            }.sheet(isPresented: $showAbout) {
                AboutView()
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
