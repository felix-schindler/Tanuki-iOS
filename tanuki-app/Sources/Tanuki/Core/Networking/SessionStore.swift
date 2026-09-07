//
//  SessionStore.swift
//  Tanuki
//
//  Created by Felix Schindler on 28.04.26.
//

import SwiftUI

#if canImport(Combine)
	import Combine
#endif

#if SKIP_BRIDGE
	@MainActor
	final class SessionStore {
		static let shared = SessionStore()

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
#else
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
#endif
