//
//  UpdateStatusView.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.01.26.
//

import SwiftUI

private enum Time: String, CaseIterable {
	case minutes_30 = "30_minutes"
	case hours_3 = "3_hours"
	case hours_8 = "8_hours"
	case days_1 = "1_day"
	case days_3 = "3_days"
	case days_7 = "7_days"
	case days_30 = "30_days"
}

struct UpdateStatusView: View {
	@Environment(\.dismiss) private var dismiss

	@State var time: Time? = nil

	private func updateStatus() async {
		var body: [String: String] = [:]

		if emoji.isNotEmpty {
			body["emoji"] = emoji
		}

		if message.isNotEmpty {
			body["message"] = message
		}

		if busy {
			body["availability"] = "busy"
		}

		if let time {
			body["clear_status_after"] = time.rawValue
		}

		do {
			_ = try await API.req(type: RestAPIStatus.self, method: .put, endpoint: "user/status", body: body)
			Notify.status(.success, "Status updated", systemImage: "checkmark")
			self.dismiss()
		} catch {
			Notify.status(.error, "Failed to update status", systemImage: "xmark")
		}
	}

	var body: some View {
		Form {
			VStack(alignment: .leading) {
				TextField("Emoji", text: $emoji)
					.textInputAutocapitalization(.never)
					.autocorrectionDisabled()
				if emoji.isNotEmpty {
					Text("Preview: :\(emoji):".emojized())
						.font(.footnote)
				}
			}
			TextField("Message", text: $message)
			Toggle("Busy", isOn: $busy)
			Picker("Clear after", selection: $time) {
				Text("Never").tag(nil as Time?)
				ForEach(Time.allCases, id: \.self) { time in
					Text(time.rawValue.replacing("_", with: " ")).tag(time)
				}
			}
		}.toolbar {
			AsyncButton("Update status", systemImage: "checkmark") {
				await updateStatus()
			}.tint(.accentColor)
		}
		.navigationTitle("Update Status")
		.modifier(ScrollDismissIfAvailable())
	}
}

#Preview {
	NavigationView {
		UpdateStatusView()
	}
}
