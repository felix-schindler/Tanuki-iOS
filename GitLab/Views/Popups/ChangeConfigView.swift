//
//  ChangeConfigView.swift
//  GitLab
//
//  Created by Felix Schindler on 02.11.21.
//

import SwiftUI

struct ChangeConfigView: View {
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    
    @State var url: String = API.domain
    @State var token: String = API.token
    
    @State var swipeError: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField(API.domain == "" ? "New GitLab URL" : "GitLab URL", text: $url)
                    .padding()
                    .textContentType(.URL)
                    .keyboardType(.URL)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                TextField(API.token == "" ? "New GitLab Token" : "GitLab Token" , text: $token)
                    .padding()
                    .disableAutocorrection(true)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                Button(action: {
                    swipeError = !validGitConfig()
                    if (!swipeError) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Text("Save configuration").frame(maxWidth: .infinity)
                }).alert(isPresented: $swipeError, content: {
                    Alert(title: Text("Error"), message: Text("Invalid configuration, check the entered url and token"), dismissButton: .default(Text("OK")))
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
