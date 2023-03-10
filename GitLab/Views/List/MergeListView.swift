//
//  MergeRequestsView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct MergeListView: View {
	@State var mergeRequests: [MergeRequest]
	@State var updateFunction: () async -> Void
	
	var body: some View {
		if (mergeRequests.isEmpty) {
			Text("You're all caught up, there are no open merge requests! 🥳")
				.font(.title)
		} else {
			List(mergeRequests, id: \.id) { mr in
				NavigationLink(destination: MergeView(mergeRequest: mr)) {
					HStack {
						Text(mr.title)
						Spacer()
						VStack(alignment: .trailing) {
							Text(mr.author.name)
							Text(mr.references.full)
						}.foregroundColor(.secondary)
							.font(.caption)
					}
				}
			}.refreshable {
				await updateFunction()
			}
		}
	}
}

struct MergeListView_Previews: PreviewProvider {
	static var previews: some View {
		MergeListView(mergeRequests: [MergeRequest](), updateFunction: {})
	}
}
