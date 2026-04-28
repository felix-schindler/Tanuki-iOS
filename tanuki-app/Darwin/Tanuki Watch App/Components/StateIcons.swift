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

	public static func getIconByState(
		_ state: GraphQLEnum<GitLabAPI.EpicState>
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
		_ state: GraphQLEnum<GitLabAPI.EpicState>
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

	init(_ state: GraphQLEnum<GitLabAPI.IssueState>) {
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

	init(_ state: GraphQLEnum<GitLabAPI.EpicState>) {
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

#Preview {
	ScrollView {
		VStack {
			ForEach(GraphQLEnum<GitLabAPI.IssueState>.allCases, id: \.self) {
				state in
				IssueStateIcon(state)
			}
		}
	}
}
