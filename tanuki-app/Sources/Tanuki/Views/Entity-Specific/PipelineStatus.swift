//
//  PipelineStatus.swift
//  Tanuki
//
//  Created by Felix Schindler on 26.02.24.
//

import GitLabAPI
import SkipKit
import SwiftUI

struct PipelineStatus: View {
	private let state: String
	private let icon: String
	private let color: SwiftUI.Color

	@State var showInfo = false

	init(_ state: String?) {
		self.state = state ?? "unknown"

		switch state?.lowercased() {
		case "created":
			self.icon = "plus.circle"
			self.color = Color.orange
		case "waiting_for_resource", "waiting_for_callback":
			self.icon = "pause.circle"
			self.color = Color.orange
		case "success":
			self.icon = "checkmark.circle"
			self.color = Color.green
		case "failed":
			self.icon = "minus.circle"
			self.color = Color.red
		case "canceled":
			self.icon = "slash.circle"
			self.color = Color.gray
		case "skipped":
			self.icon = "chevron.right.circle"
			self.color = Color.gray
		case "manual":
			self.icon = "person.crop.circle"
			self.color = Color.primary
		case "scheduled":
			self.icon = "hourglass.circle"
			self.color = Color.primary
		default:
			self.icon = "arrow.2.circlepath.circle"
			self.color = Color.orange
		}
	}

	public var body: some View {
		VStack {
			RoundIconButton("Pipeline status", icon: icon) {
				HapticFeedback.play(.pick)
				showInfo = true
			}
			.tint(self.color)
			.controlSize(.mini)
		}.sheet(isPresented: $showInfo) {
			VStack(alignment: .leading) {
				PopupHeader(
					title: "Pipeline status",
					onClose: {
						showInfo = false
					})
				Text("The current Pipeline status is \"\(state)\"")
				Spacer()
			}
			.padding()
			.modifier(PresentationDetendsIfAvailable())
		}
	}
}
