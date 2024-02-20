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
	@State var loadFailed = false
	
	@State var projectId = 0
	@State var userId = 0
	
	@State var showClose = false
	
	var body: some View {
		List {
			if (events != nil) {
				if (events!.isEmpty) {
					Text("There are no events")
				} else {
					ForEach(events!, id: \.id) { event in
						VStack(alignment: .leading) {
							Text(event.createdAt.toString())
								.font(.footnote)
								.foregroundStyle(.secondary)
							Text(getStupidText(event: event))
						}
					}
				}
			} else if (loadFailed) {
				Text(Messages.failedToLoad)
			} else {
				ProgressView()
			}
		}.toolbar {
			if (showClose) {
				RoundIconButton("Close", icon: "xmark") {
					self.presentationMode.wrappedValue.dismiss()
				}.tint(.secondary)
			}
		}.onAppear {
			Task {
				await getEvents()
			}
		}.refreshable {
			await getEvents()
		}.navigationBarTitle("Events")
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
		var endpoint: String
		
		if (projectId != 0) {
			endpoint = "projects/\(projectId)/events"
		} else if (userId != 0) {
			endpoint = "users/\(userId)/events"
		} else {
			endpoint = "events"
		}
		
		events = await API.get(type: [Event].self, endpoint: endpoint)
		loadFailed = (events == nil)
	}
}

#Preview {
	NavigationStack {
		EventsView(events: nil, showClose: true)
	}
}
