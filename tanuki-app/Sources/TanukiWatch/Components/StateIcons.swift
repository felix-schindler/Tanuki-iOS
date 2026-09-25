#if os(watchOS)
	import ApolloAPI
	import GitLabAPI
	import SwiftUI

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
			Label(self.state, systemImage: self.icon)
				.foregroundStyle(self.color)
				.labelStyle(.iconOnly)
		}
	}

	struct MergeStateIcon: View {
		private let state: GraphQLEnum<GitLabAPI.MergeRequestState>
		private let icon: Image
		private let color: SwiftUI.Color

		init(_ state: GraphQLEnum<GitLabAPI.MergeRequestState>) {
			self.state = state

			switch state {
			case .opened:
				icon = Image(systemName: "arrow.triangle.branch")
				color = Color.green
			case .merged:
				icon = Image(systemName: "arrow.triangle.merge")
				color = Color.blue
			case .closed:
				icon = Image(systemName: "xmark.circle")
				color = Color.red
			case .locked:
				icon = Image(systemName: "lock")
				color = Color.secondary
			default:
				icon = Image(systemName: "arrow.triangle.branch")
				color = Color.primary
			}
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
#endif
