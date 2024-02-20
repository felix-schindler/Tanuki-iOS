//
//  AsyncButton.swift
//  GitLab
//
//  Created by Felix Schindler on 19.03.23.
//

import SwiftUI

struct AsyncButton<Label: View>: View {
	var action: () async -> Void
	var role: ButtonRole?
	@ViewBuilder var label: () -> Label
	
	@State private var isPerformingTask = false
	
	var body: some View {
		Button(
			role: role,
			action: {
				isPerformingTask = true
				
				Task {
					await action()
					isPerformingTask = false
				}
			},
			label: {
				ZStack {
					// We hide the label by setting its opacity
					// to zero, since we don't want the button's
					// size to change while its task is performed:
					label().opacity(isPerformingTask ? 0 : 1)
					
					if isPerformingTask {
						ProgressView()
					}
				}
			}
		).disabled(isPerformingTask)
	}
}

extension AsyncButton {
	enum ActionOption: CaseIterable {
		case disableButton
		case showProgressView
	}
}

extension AsyncButton where Label == Text {
	init(_ label: String,
			 role: ButtonRole? = nil,
			 actionOptions: Set<ActionOption> = Set(ActionOption.allCases),
			 action: @escaping () async -> Void) {
		self.init(action: action, role: role) {
			Text(label)
		}
	}
}

extension AsyncButton where Label == Image {
	init(systemImage: String,
			 role: ButtonRole? = nil,
			 actionOptions: Set<ActionOption> = Set(ActionOption.allCases),
			 action: @escaping () async -> Void) {
		self.init(action: action, role: role) {
			Image(systemName: systemImage)
		}
	}
}
