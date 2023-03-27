//
//  EventsView.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct EventsView: View {
	@Environment(\.presentationMode)
	var presentationMode: Binding<PresentationMode>
	
	@State var events: [Event]? = nil
	@State var loadFailed: Bool = false
	
	var body: some View {
		NavigationView {
			VStack {
				if (events != nil) {
					if (events!.isEmpty) {
						Text("There are no events")
					} else {
						List(events!, id: \.id) { event in
							VStack(alignment: .leading) {
								Text(getStupidText(event: event))
								Text(event.createdAt.toString())
									.font(.callout)
									.foregroundColor(.secondary)
							}
						}.refreshable {
							await getEvents()
						}
					}
				} else {
					Spacer()
					if (loadFailed) {
						Text("Failed to load, please check your internet connection and your token")
					} else {
						ProgressView("Loading")
					}
					Spacer()
				}
			}.navigationBarTitle("Events")
				.navigationBarItems(trailing: Button("Close", action: {self.presentationMode.wrappedValue.dismiss()}))
				.onAppear {
					Task {
						await getEvents()
					}
				}
		}
	}
	
	private func getStupidText(event: Event) -> String {
		var ret: String = event.author.username
		ret += " " + event.actionName
		if (event.targetType != nil) {
			ret += " \(event.targetType!)"
		}; if (event.targetIid != nil) {
			ret += " \(event.targetIid!)"
		}; if (event.targetTitle != nil) {
			ret += " '\(event.targetTitle!.emojized())'"
		}; if (event.pushData != nil) {
			ret += " \(event.pushData!.refType) '\(event.pushData!.ref)'"
			if (event.pushData!.commitTitle != nil) {
				ret += " with message '\(event.pushData!.commitTitle!.emojized())'"
			}
		}
		return ret.trim()
	}
	
	private func getEvents() async -> Void {
		events = await API.get(type: [Event].self, endpoint: "events")
		loadFailed = (events == nil)
	}
}
