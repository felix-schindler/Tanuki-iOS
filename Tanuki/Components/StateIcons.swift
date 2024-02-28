//
//  StateIcons.swift
//  Tanuki
//
//  Created by Felix Schindler on 27.02.24.
//

import GitLabAPI
import SwiftUI

struct IssueStateHelper {
	public static func getColorByState(
		_ state: GraphQLEnum<GitLabAPI.IssueState>
	) -> SwiftUI.Color {
		switch state {
		case .opened:
			Color.green
		case .closed:
			Color.blue
		case .locked:
			Color.secondary
		default:
			Color.primary
		}
	}

	public static func getIconByState(
		_ state: GraphQLEnum<GitLabAPI.IssueState>
	) -> String {
		switch state {
		case .opened:
			"smallcircle.circle"
		case .closed:
			"minus.circle"
		case .locked:
			"lock.circle"
		default:
			"smallcircle.circle"
		}
	}
}

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

	public var body: some View {
		Label(self.state.rawValue, systemImage: self.icon)
			.foregroundStyle(self.color)
			.labelStyle(.iconOnly)
	}
}

struct MergeStateHelper {
	public static func getColorByState(
		_ state: GraphQLEnum<GitLabAPI.MergeRequestState>
	) -> SwiftUI.Color {
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

	public static func getIconByState(
		_ state: GraphQLEnum<GitLabAPI.MergeRequestState>
	) -> String {
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

	public var body: some View {
		Label(self.state.rawValue, systemImage: self.icon)
			.foregroundStyle(self.color)
			.labelStyle(.iconOnly)
	}
}

struct MergeStatus: View {
	private let status: GraphQLEnum<GitLabAPI.MergeStatus>
	private let icon: String
	private let color: SwiftUI.Color

	init(_ status: GraphQLEnum<GitLabAPI.MergeStatus>) {
		self.status = status

		switch status {
		case .canBeMerged:
			self.icon = "checkmark"
			self.color = Color.green
		case .cannotBeMerged:
			self.icon = "xmark"
			self.color = Color.red
		case .checking:
			self.icon = "arrow.2.circlepath"
			self.color = Color.orange
		case .unchecked, .cannotBeMergedRecheck:
			self.icon = "questionmark"
			self.color = Color.secondary
		default:
			self.icon = "questionmark"
			self.color = Color.primary
		}
	}

	public var body: some View {
		Label(
			self.status.rawValue
				.split(separator: "_")
				.joined(separator: " ")
				.lowercased()
				.firstCapitalized,
			systemImage: self.icon
		).foregroundStyle(self.color)
	}
}

struct DetailedMergeStatusView: View {
	private var detailedStatus: GraphQLEnum<GitLabAPI.DetailedMergeStatus>
	private var msg: String

	init(_ detailedStatus: GraphQLEnum<GitLabAPI.DetailedMergeStatus>) {
		self.detailedStatus = detailedStatus

		msg =
			switch detailedStatus {
			case .unchecked:
				"Merge status has not been checked."
			case .checking:
				"Currently checking for mergeability."
			case .mergeable:
				"Branch can be merged."
			case .brokenStatus:
				"Can not merge the source into the target branch, potential conflict."
			case .commitsStatus:
				"Source branch exists and contains commits."
			case .ciMustPass:
				"Pipeline must succeed before merging."
			case .ciStillRunning:
				"Pipeline is still running."
			case .discussionsNotResolved:
				"Discussions must be resolved before merging."
			case .draftStatus:
				"Merge request must not be draft before merging."
			case .notOpen:
				"Merge request must be open before merging."
			case .notApproved:
				"Merge request must be approved before merging."
			case .blockedStatus:
				"Merge request dependencies must be merged."
			case .policiesDenied:
				"There are denied policies for the merge request."
			case .externalStatusChecks:
				"Status checks must pass."
			case .preparing:
				"Merge request diff is being created."
			case .jiraAssociation:
				"Either the title or description must reference a Jira issue."
			case .conflict:
				"There are conflicts between the source and target branches."
			case .needRebase:
				"Merge request needs to be rebased."
			default:
				"Unknown error"
			}
	}

	var body: some View {
		Label(
			title: {
				Text(msg)
			},
			icon: {
				Image(systemName: "minus.circle.fill")
					.foregroundStyle(.red)
			})
	}
}

#Preview {
	HStack {
		VStack {
			ForEach(GraphQLEnum<GitLabAPI.IssueState>.allCases, id: \.self) {
				state in
				IssueStateIcon(state)
			}
		}
		VStack {
			ForEach(
				GraphQLEnum<GitLabAPI.MergeRequestState>.allCases, id: \.self
			) { state in
				MergeStateIcon(state)
			}
		}
		VStack {
			ForEach(GraphQLEnum<GitLabAPI.MergeStatus>.allCases, id: \.self) {
				status in
				MergeStatus(status)
			}
		}
	}
}
