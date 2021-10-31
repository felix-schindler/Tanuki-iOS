//
//  EventsView.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct Event: Decodable {
    var id: Int
    var actionName: String
    var targetType: String? = ""
    var targetTitle: String? = ""
    // var pushData: PushData? = nil
    var author: UserSmall
}

struct PushData: Decodable {
    var refType: String
    var ref: String
    var commitTitle: String
}

struct EventsView: View {
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    
    @State var events: [Event]? = nil
    @State var noConnection: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                if (events != nil) {
                    List(events!, id: \.id) { event in
                        Text(getStupidText(event: event))
                    }.listStyle(.plain)
                    .refreshable {
                        await getEvents()
                    }
                    Spacer()
                } else {
                    Spacer()
                    if (noConnection) {
                        Text("Failed to load, please check your internet connection and your token")
                            .foregroundColor(.red)
                    } else {
                        ProgressView("Loading")
                    }
                    Spacer()
                }
            }
            .onAppear {
                Task.init {
                    await getEvents()
                }
            }
            .navigationBarTitle("Events")
            .navigationBarItems(trailing: Button("Close", action: {self.presentationMode.wrappedValue.dismiss()}))
        }
    }
    
    private func getStupidText(event: Event) -> String {
        var ret: String = event.author.name
        ret += " " + event.actionName
        if (event.targetType != nil) {
            ret += " \(event.targetType!)"
        }; if (event.targetTitle != nil) {
            ret += " '\(event.targetTitle!)'"
        }
        return ret.trim()
    }
    
    private func getEvents() async -> Void {
        do {
            let apiData: Data? = API.GET(endpoint: "events")
            if (apiData != nil) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                events = try decoder.decode([Event].self, from: apiData!)
            } else {
                noConnection = true
            }
        } catch let jsonError as NSError {
            print("JSON error \(jsonError.localizedDescription)")
        }
    }
}
