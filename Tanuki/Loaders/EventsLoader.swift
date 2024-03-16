//
//  EventsView.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct EventsLoader: View {
	private var projectId = 0
	private var userId = 0

	@State
	private var events: [Event]? = nil
	
	@State
	private var loadFailed = false
	
	init() {
	}
	
	init(userId: Int) {
		self.userId = userId
	}
	
	init(projectId: Int) {
		self.projectId = projectId
	}

	public var body: some View {
		List {
			if events != nil {
				if events!.isEmpty {
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
			} else if loadFailed {
				Text(failedToLoad)
			} else {
				ProgressView()
			}
		}.onAppear {
			Task {
				await getEvents()
			}
		}.refreshable {
			await getEvents()
		}.navigationBarTitle("Activity")
	}

	private func getStupidText(event: Event) -> String {
		var ret: String = "@\(event.author.username)"
		ret += " " + event.actionName
		if event.targetType != nil {
			ret += " \(event.targetType!)"
		}
		if event.targetIid != nil {
			ret += " \(event.targetIid!)"
		}
		if event.targetTitle != nil {
			ret += " '\(event.targetTitle!.emojized())'"
		}
		if event.pushData != nil {
			ret += " \(event.pushData!.refType) '\(event.pushData!.ref)'"
			if event.pushData!.commitTitle != nil {
				ret +=
					" with message '\(event.pushData!.commitTitle!.emojized())'"
			}
		}
		return ret.trimmingCharacters(in: .whitespacesAndNewlines)
	}

	private func getEvents() async {
		var endpoint: String

		if projectId != 0 {
			endpoint = "projects/\(projectId)/events"
		} else if userId != 0 {
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
		EventsLoader()
	}
}
