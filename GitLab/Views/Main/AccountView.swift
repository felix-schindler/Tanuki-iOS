//
//  AccountView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct AccountView: View {
    @State var url = ""
    @State var token = ""

    var body: some View {
        NavigationView {
            VStack {
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
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
