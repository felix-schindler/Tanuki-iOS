//
//  AccountView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct AccountView: View {
    @State var user: User? = nil
    @State var status: UserStatus? = nil
    @State var noConnection: Bool = false
    
    @State var showSettings: Bool = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if (user != nil) {
                    HStack {
                        AsyncImage(url: URL(string: user!.avatarUrl)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                        } placeholder: {
                            ProgressView()
                        }.frame(width: 50, height: 50)
                        VStack {
                            Text(user!.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(user!.username)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    if (status != nil) {
                        VStack {
                            Text("Status")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            HStack {
                                Text((":" + status!.emoji + ":").emojized())
                                Text(status!.message)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }.padding(.vertical, 5)
                    }
                    if (user!.bio != "") {
                        VStack {
                            Text("Bio")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(user!.bio)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }.padding(.vertical, 5)
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
                    HStack {
                        Image(systemName: "person.2")
                        Text("\(user!.followers) followers · \(user!.following) following")
                    }
                } else {
                    if (noConnection) {
                        Text("Failed to load, please check your internet connection and your token")
                            .foregroundColor(.red)
                    } else {
                        Spacer()
                        ProgressView("Loading")
                    }
                }
                Spacer()
            }.padding()
            .onAppear {
                Task.init {
                    await getUser()
                    await getStatus()
                }
            }.toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button (action: {showSettings = true}) {
                        Image(systemName: "gearshape")
                    }
                }
            }.sheet(isPresented: $showSettings) {
                SettingsView()
            }.navigationTitle("Account")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func getUser() async -> Void {
        do {
            let apiData: Data? = API.GET(endpoint: "user")
            if (apiData != nil) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                user = try decoder.decode(User.self, from: apiData!)
            } else {
                noConnection = true
            }
        } catch let jsonError as NSError {
            print("JSON error \(jsonError.localizedDescription)")
        }
    }
    
    private func getStatus() async -> Void {
        do {
            let apiData: Data? = API.GET(endpoint: "user/status")
            if (apiData != nil) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                status = try decoder.decode(UserStatus.self, from: apiData!)
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
