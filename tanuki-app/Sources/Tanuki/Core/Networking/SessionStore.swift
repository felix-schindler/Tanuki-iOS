//
//  SessionStore.swift
//  Tanuki
//
//  Created by Felix Schindler on 28.04.26.
//

import SwiftUI

@MainActor
final class SessionStore: ObservableObject {
	static let shared = SessionStore()

	@Published
	private(set) var needsSetup: Bool

	private init() {
		needsSetup = InstanceManager.selected == nil
	}

	func setNeedsSetup(_ value: Bool) {
		needsSetup = value
	}

	func refresh() {
		needsSetup = InstanceManager.selected == nil
	}
}
