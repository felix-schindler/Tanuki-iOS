//
//  StateIcons.swift
//  Tanuki
//
//  Created by Felix Schindler on 27.02.24.
//

import SwiftUI
import GitLabAPI

struct IssueStateIcon: View {
	private let state: GraphQLEnum<GitLabAPI.IssueState>
	private let icon: String
	private let color: SwiftUI.Color

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

struct MergeStateHelper {
	public static func getColorByState(_ state: GraphQLEnum<GitLabAPI.MergeRequestState>) -> SwiftUI.Color {
		switch state {
		case .opened:
			return Color.green
		case .merged:
			return Color.blue
		case .closed:
			return Color.red
		case .locked:
			return Color.secondary
		default:
			return Color.primary
		}
	}

	public static func getIconByState(_ state: GraphQLEnum<GitLabAPI.MergeRequestState>) -> String {
		switch state {
		case .opened:
			return "arrow.triangle.pull"
		case .merged:
			return "arrow.triangle.merge"
		case .closed:
			return "arrow.triangle.swap"
		case .locked:
			return "lock"
		default:
			return "arrow.triangle.pull"
		}
	}
}

struct MergeStateIcon: View {
	private let state: GraphQLEnum<GitLabAPI.MergeRequestState>
	private let icon: String
	private let color: SwiftUI.Color

	init(_ state: GraphQLEnum<GitLabAPI.MergeRequestState>) {
		self.state = state
		self.icon = MergeStateHelper.getIconByState(state)
		self.color = MergeStateHelper.getColorByState(state)
	}

	var body: some View {
		Label(self.state.rawValue, systemImage: self.icon)
			.foregroundStyle(self.color)
			.labelStyle(.iconOnly)
	}
}

struct MergeStatusHelper {
	public static func getColorByStatus(_ status: GraphQLEnum<GitLabAPI.MergeStatus>) -> SwiftUI.Color {
	    switch status {
        case .canBeMerged:
            return Color.green
        case .cannotBeMerged:
            return Color.red
		case .checking:
			return Color.orange
        case .unchecked, .cannotBeMergedRecheck:
            return Color.secondary
        default:
            return Color.primary
        }
	}
	
	public static func getIconByStatus(_ status: GraphQLEnum<GitLabAPI.MergeStatus>) -> String {
        switch status {
        case .canBeMerged:
            return "checkmark"
        case .cannotBeMerged:
            return "xmark"
		case .checking:
			return "arrow.2.circlepath"
        case .unchecked, .cannotBeMergedRecheck:
            return "questionmark"
        default:
            return "questionmark"
        }
    }
}

struct MergeStatus: View {
	private let status: GraphQLEnum<GitLabAPI.MergeStatus>
	private let icon: String
	private let color: SwiftUI.Color
	
	init(_ status: GraphQLEnum<GitLabAPI.MergeStatus>) {
		self.status = status
		self.icon = MergeStatusHelper.getIconByStatus(status)
		self.color = MergeStatusHelper.getColorByStatus(status)
	}
	
	var body: some View {
		Label(self.status.rawValue, systemImage: self.icon)
			.foregroundStyle(self.color)
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
		VStack {
			ForEach(GraphQLEnum<GitLabAPI.MergeStatus>.allCases, id: \.self) { status in
				MergeStatus(status)
			}
		}
	}
}
