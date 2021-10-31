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
    
    var body: some View {
        NavigationView {
            // TODO implement
            VStack {
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
                    API.setBase(url: url)
                    API.setToken(token: token)
                }, label: {
                    Text("Save configuration").frame(maxWidth: .infinity)
                }).tint(.accentColor)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle)
                .controlSize(.large)
            }.padding()
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button("Close", action: {self.presentationMode.wrappedValue.dismiss()}))
        }
    }
}
