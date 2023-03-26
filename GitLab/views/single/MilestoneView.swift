//
//  MilestoneView.swift
//  GitLab
//
//  Created by Felix Schindler on 26.03.23.
//

import SwiftUI
import MarkdownUI

struct MilestoneView: View {
	@State var milestone: Milestone
	
	var body: some View {
		List {
			Section("Info") {
				Text(milestone.title.emojized())
					.font(.title)
					.fontWeight(.semibold)
				if (milestone.description != "") {
					Markdown(milestone.description.emojized())
				}
			}
			
			if (milestone.dueDate != nil) {
				Section("Details") {
					HStack {
						Image(systemName: "calendar.badge.clock")
						Text(Date.fromToString(milestone.dueDate!))
					}
				}
			}
		}.toolbar {
			ToolbarItemGroup(placement: .navigationBarTrailing) {
				 Text(milestone.state.firstCapitalized)
					 .font(.footnote)
					 .padding(.horizontal, 6)
					 .padding(.vertical, 4)
					 .background(milestone.state == "active" ? .green : .blue)
					 .foregroundColor(.white)
					 .cornerRadius(10)
				 Button(action: {
					 URL(string: milestone.webUrl)!.share()
				 }) {
					 Image(systemName: "square.and.arrow.up")
				 }
			 }
		 }.navigationTitle("Milestone")
			.navigationBarTitleDisplayMode(.inline)
	}
}

struct MilestoneView_Previews: PreviewProvider {
	static var previews: some View {
		MilestoneView(milestone: Milestone(id: 3034285, iid: 2, title: "1.1.0", description: "First things after initial App Store release", state: "active", dueDate: "2023-03-26", webUrl: "https://gitlab.com/felix-schindler/gitlab-ios/-/milestones/2"))
	}
}
