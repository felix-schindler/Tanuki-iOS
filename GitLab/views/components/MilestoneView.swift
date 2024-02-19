//
//  MilestoneView.swift
//  GitLab
//
//  Created by Felix Schindler on 13.06.23.
//

import SwiftUI
import MarkdownUI

struct MilestoneView: View {
	@State var id: Int
	@State var milestone: Milestone
	
	var body: some View {
		NavigationLink(destination: IssuesLoader(id: id, state: (milestone.state == "active" ? IssueState.opened : IssueState.all), milestone: milestone.title)) {
			HStack {
				if (milestone.state == "closed") {
					Image(systemName: "flag.circle")
						.foregroundStyle(.red)
				} else if (milestone.expired) {
					Image(systemName: "flag.circle")
						.foregroundStyle(.orange)
				} else {
					Image(systemName: "flag.circle")
						.foregroundStyle(.green)
				}
				VStack(alignment: .leading) {
					Text(milestone.title.emojized())
						.fontWeight(.medium)
					if (milestone.description != "") {
						Markdown(milestone.description.emojized())
							.markdownTheme(.small)
					}
					
					let showStartDate = (milestone.startDate != nil)
					let showDueDate = (milestone.dueDate != nil)
					
					if (showStartDate || showDueDate) {
						HStack {
							Image(systemName: "calendar.badge.clock")
							if (showStartDate) {
								Text(Date.fromToString(milestone.startDate!))
							}
							if (showStartDate && showDueDate) {
								Text("-")
							}
							if (showDueDate) {
								Text(Date.fromToString(milestone.dueDate!))
							}
						}.font(.footnote)
					}
				}
			}.swipeActions {
				AsyncButton(systemImage: "square.and.arrow.up") {
					await URL(string: milestone.webUrl)!.share()
				}
			}
		}
		
	}
}

struct MilestoneView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			MilestoneView(id: 0, milestone: Milestone(id: 3034284, iid: 1, title: "1.0.0", description: "", state: "closed", startDate: nil, dueDate: "2023-06-13", expired: false, webUrl: "https://gitlab.com/felix-schindler/gitlab-ios/-/milestones/3"))
		}
	}
}
