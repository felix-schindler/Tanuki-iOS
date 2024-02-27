//
//  StateIcons.swift
//  Tanuki
//
//  Created by Felix Schindler on 27.02.24.
//

import SwiftUI
import GitLabAPI

struct IssueStateIcon: View {
	private var state: GraphQLEnum<GitLabAPI.IssueState>
	private var icon: String
	private var color: SwiftUI.Color
	
	init(_ state: GraphQLEnum<GitLabAPI.IssueState>) {
		self.state = state
		
		switch state {
		case .opened:
			icon = "smallcircle.circle"
			color = Color.green
		case .closed:
			icon = "minus.circle"
			color = Color.blue
		case .locked:
			icon = "lock.circle"
			color = Color.secondary
		default:
			icon = "smallcircle.circle"
			color = Color.primary
		}
	}
	
    var body: some View {
		Label(self.state.rawValue, systemImage: self.icon)
			.foregroundStyle(self.color)
			.labelStyle(.iconOnly)
    }
}

struct MergeStateIcon: View {
	private var state: GraphQLEnum<GitLabAPI.MergeRequestState>
	private var icon: String
	private var color: SwiftUI.Color
	
	init(_ state: GraphQLEnum<GitLabAPI.MergeRequestState>) {
		self.state = state
		
		switch state {
		case .opened:
			icon = "arrow.triangle.pull"
			color = Color.green
		case .merged:
			icon = "arrow.triangle.merge"
			color = Color.blue
		case .closed:
			icon = "arrow.triangle.swap"
			color = Color.red
		case .locked:
			icon = "lock"
			color = Color.secondary
		default:
			icon = "arrow.triangle.pull"
			color = Color.primary
		}
	}
	
	var body: some View {
		Label(self.state.rawValue, systemImage: self.icon)
			.foregroundStyle(self.color)
			.labelStyle(.iconOnly)
	}
}

#Preview {
	HStack {
		VStack {
			ForEach(GraphQLEnum<GitLabAPI.IssueState>.allCases, id: \.self) { state in
				IssueStateIcon(state)
			}
		}
		VStack {
			ForEach(GraphQLEnum<GitLabAPI.MergeRequestState>.allCases, id: \.self) { state in
				MergeStateIcon(state)
			}
		}
	}
}
