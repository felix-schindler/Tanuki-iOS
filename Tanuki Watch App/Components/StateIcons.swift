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
		self.icon = IssueStateHelper.getIconByState(state)
		self.color = IssueStateHelper.getColorByState(state)
	}

	public var body: some View {
		Label(self.state.rawValue.firstCapitalized, systemImage: self.icon)
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
			return "arrow.triangle.branch"
		case .merged:
			return "arrow.triangle.merge"
		case .closed:
			return "xmark.circle"
		case .locked:
			return "lock"
		default:
			return "arrow.triangle.branch"
		}
	}
}

struct MergeStateIcon: View {
	private let state: GraphQLEnum<GitLabAPI.MergeRequestState>
	private let icon: Image
	private let color: SwiftUI.Color

	init(_ state: GraphQLEnum<GitLabAPI.MergeRequestState>) {
		self.state = state
		self.icon = Image(systemName: MergeStateHelper.getIconByState(state))
		self.color = MergeStateHelper.getColorByState(state)
	}

	public var body: some View {
		Label(
			title: {
				Text(self.state.rawValue.firstCapitalized)
			},
			icon: {
				self.icon
			}
		)
		.foregroundStyle(self.color)
		.labelStyle(.iconOnly)
	}
}

#Preview {
	ScrollView {
		VStack {
			ForEach(GraphQLEnum<GitLabAPI.IssueState>.allCases, id: \.self) {
				state in
				IssueStateIcon(state)
			}
			ForEach(GraphQLEnum<GitLabAPI.MergeRequestState>.allCases, id: \.self) {
				state in
				MergeStateIcon(state)
			}
		}
	}
}
