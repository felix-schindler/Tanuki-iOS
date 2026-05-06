//
//  StateIcons.swift
//  Tanuki
//
//  Created by Felix Schindler on 27.02.24.
//

import IOSGitLabAPI
import SwiftUI

struct IssueStateHelper {
	public static func getColorByState(
		_ state: GraphQLEnum<IOSGitLabAPI.IssueState>
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
		_ state: GraphQLEnum<IOSGitLabAPI.IssueState>
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

	public static func getIconByState(
		_ state: GraphQLEnum<IOSGitLabAPI.EpicState>
	) -> String {
		switch state {
		case .opened:
			"smallcircle.circle"
		case .closed:
			"minus.circle"
		default:
			"smallcircle.circle"
		}
	}

	public static func getColorByState(
		_ state: GraphQLEnum<IOSGitLabAPI.EpicState>
	) -> SwiftUI.Color {
		switch state {
		case .opened:
			Color.green
		case .closed:
			Color.blue
		default:
			Color.primary
		}
	}
}

struct IssueStateIcon: View {
	private let state: String
	private let icon: String
	private let color: SwiftUI.Color

	init(_ state: GraphQLEnum<IOSGitLabAPI.IssueState>) {
		self.state = state.rawValue

		switch state {
		case .opened:
			icon = "smallcircle.circle"
			color = Color.green
			break
		case .closed:
			icon = "minus.circle"
			color = Color.blue
			break
		case .locked:
			icon = "lock.circle"
			color = Color.secondary
			break
		default:
			icon = "smallcircle.circle"
			color = Color.primary
			break
		}
	}

	init(_ state: GraphQLEnum<IOSGitLabAPI.EpicState>) {
		self.state = state.rawValue

		switch state {
		case .opened:
			icon = "smallcircle.circle"
			color = Color.green
			break
		case .closed:
			icon = "minus.circle"
			color = Color.blue
			break
		default:
			icon = "smallcircle.circle"
			color = Color.primary
			break
		}
	}

	public var body: some View {
		Label(self.state, systemImage: self.icon)
			.foregroundStyle(self.color)
			.labelStyle(.iconOnly)
	}
}

struct MergeStateHelper {
	public static func getColorByState(
		_ state: GraphQLEnum<IOSGitLabAPI.MergeRequestState>
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
		_ state: GraphQLEnum<IOSGitLabAPI.MergeRequestState>
	) -> Image {
		switch state {
		case .opened:
			return Image(systemName: "arrow.triangle.branch")
		case .merged:
			return Image(systemName: "arrow.triangle.merge")
		case .closed:
			return Image(systemName: "xmark.circle")
		case .locked:
			return Image(systemName: "lock")
		default:
			return Image(systemName: "arrow.triangle.branch")
		}
	}
}

struct MergeStateIcon: View {
	private let state: GraphQLEnum<IOSGitLabAPI.MergeRequestState>
	private let icon: Image
	private let color: SwiftUI.Color

	init(_ state: GraphQLEnum<IOSGitLabAPI.MergeRequestState>) {
		self.state = state
		self.icon = MergeStateHelper.getIconByState(state)
		self.color = MergeStateHelper.getColorByState(state)
	}

	public var body: some View {
		Label(
			title: {
				Text(self.state.rawValue)
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
			ForEach(GraphQLEnum<IOSGitLabAPI.IssueState>.allCases, id: \.self) {
				state in
				IssueStateIcon(state)
			}
			ForEach(GraphQLEnum<IOSGitLabAPI.MergeRequestState>.allCases, id: \.self) {
				state in
				MergeStateIcon(state)
			}
		}
	}
}
