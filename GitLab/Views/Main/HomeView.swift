//
//  HomeView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            List {
                Section (header: Text("Your work")) {
                    NavigationLink(destination: IssuesView()) {
                        HStack {
                            Image(systemName: "square.on.square")
                            Text("Issues")
                        }
                    }
                    NavigationLink(destination: IssuesView()) {
                        HStack {
                            Image(systemName: "arrow.merge")
                            Text("Merge Requests")
                        }
                    }
                    NavigationLink(destination: IssuesView()) {
                        HStack {
                            Image(systemName: "folder")
                            Text("Repositories")
                        }
                    }
                }.headerProminence(.increased)
            }
            .navigationBarTitle("Home")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("New issue")
                    }) {
                        Image(systemName: "plus.circle")
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
