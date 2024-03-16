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
							HStack {
								ScrollView(.horizontal) {
									AuthorView(event.author)
								}
								Spacer()
								Text(event.createdAt.toString(timeStyle: .short))
							}.font(.footnote)
							Text(getStupidText(event: event))
						}
					}
				}
			} else {
				VStack {
					Image(systemName: "clock.arrow.circlepath")
						.resizable()
						.scaledToFit()
						.foregroundStyle(.accent)
						.frame(width: 50, height: 50)
					if loadFailed {
						Text(failedToLoad)
					} else {
						ProgressView("Loading activities")
					}
				}.frame(maxWidth: .infinity, minHeight: 100)
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
		var ret = event.actionName.firstCapitalized
		if let targetType = event.targetType {
			ret += " \(targetType)"
		}
		if let targetIid = event.targetIid {
			ret += " \(targetIid)"
		}
		if let targetTitle = event.targetTitle?.emojized() {
			ret += " '\(targetTitle)'"
		}
		if let pushData = event.pushData {
			ret += " \(pushData.refType) '\(pushData.ref)'"
			if let commitTitle = pushData.commitTitle?.emojized() {
				ret += " with message '\(commitTitle)'"
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
