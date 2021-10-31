//
//  AccountView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct User: Decodable {
    var id: Int
    var name: String
    var username: String
    var avatarUrl: String
    var bio: String
    var location: String
    var publicEmail: String
    var websiteUrl: String
}

struct Status: Decodable {
    // var emoji: String
    var message: String
}

struct AccountView: View {
    @State var url = ""
    @State var token = ""
    
    @State var user: User? = nil
    @State var status: Status? = nil
    @State var noConnection: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                if (user != nil) {
                    AsyncImage(url: URL(string: user!.avatarUrl))
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .cornerRadius(20)
                    Text(user!.name)
                    Text(user!.username)
                        .foregroundColor(.secondary)
                    if (status != nil) {
                        Text("Status")
                            .font(.headline)
                        Text(status!.message)
                    }
                    if (user!.bio != "") {
                        Text("Bio")
                            .font(.headline)
                        Text(user!.bio)
                    }
                    if (user!.location != "") {
                        HStack {
                            Image(systemName: "mappin.circle")
                            Text(user!.location)
                        }
                    }
                    if (user!.publicEmail != "") {
                        HStack {
                            Image(systemName: "envelope")
                            Text(user!.publicEmail)
                        }
                    }
                    if (user!.websiteUrl != "") {
                        HStack {
                            Image(systemName: "paperclip.circle")
                            Link(user!.websiteUrl, destination: URL(string: user!.websiteUrl)!)
                        }
                    }
                } else {
                    if (noConnection) {
                        Text("No internet connection")
                            .foregroundColor(.red)
                    } else {
                        ProgressView("Loading")
                    }
                }
                Spacer()
                TextField("New GitLab URL", text: $url)
                    .padding()
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                    .onSubmit {
                        if (url != "") {
                            API.setBase(url: url)
                        }
                    }
                TextField("New GitLab Token", text: $token)
                    .padding()
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                    .onSubmit {
                        if (token != "") {
                            API.setBase(url: token)
                        }
                    }
            }.padding()
            .navigationTitle("Account")
            .onAppear {
                Task.init {
                    await getUser()
                }
            }
        }
    }
    
    private func getUser() async -> Void {
        do {
            let apiData: Data? = API.GET(endpoint: "user")
            if (apiData != nil) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                user = try decoder.decode(User.self, from: apiData!)
                Task.init {
                    await getStatus()
                }
            } else {
                noConnection = true
            }
        } catch let jsonError as NSError {
            print("JSON error \(jsonError.localizedDescription)")
        }
    }
    
    private func getStatus() async -> Void {
        do {
            let apiData: Data? = API.GET(endpoint: "user")
            if (apiData != nil) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                status = try decoder.decode(Status.self, from: apiData!)
            } else {
                noConnection = true
            }
        } catch let jsonError as NSError {
            print("JSON error \(jsonError.localizedDescription)")
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
