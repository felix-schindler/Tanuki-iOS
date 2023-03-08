//
//  SettingsView.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    
    @State var url = ""
    @State var token = ""
    
    var body: some View {
        VStack {
            // TODO: Display app icon
            Spacer()
            VStack(alignment: .leading) {
                Text("Welcome to")
                Text("Tanuki for GitLab")
                    .foregroundColor(.accentColor)
            }.font(.system(size: 40, weight: .heavy, design: .default))
            Text("The best way to use GitLab on iPhone and iPad")
                .padding(.top)
            Spacer()
            VStack {
                HStack {
                    Image(systemName: "tray.2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                    VStack {
                        Text("Everything in one place. Your hand.")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("View projects, merge requests, issues, pipelines, branches, commits, files and many more.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                HStack {
                    Image(systemName: "iphone")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                    VStack {
                        Text("Mobile First")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("You can use it on your phone.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                HStack {
                    Image(systemName: "bubble.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                    VStack {
                        Text("Post with ease")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Create new issues and notes on the go with Markdown.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            Spacer()
            Button(action: {self.presentationMode.wrappedValue.dismiss()}, label: {
                Text("Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }).tint(.accentColor)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle)
            .controlSize(.large)
        }.padding()
    }
}
