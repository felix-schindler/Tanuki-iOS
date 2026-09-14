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
	/// On Android the store cannot be an `ObservableObject`, so a plain class cannot drive
	/// SwiftUI presentation state: reading `needsSetup` in a view body creates no dependency.
	/// Instead the root view keeps the presentation flag in real `@State` and listens here.
	@MainActor
	final class SessionStore {
		static let shared = SessionStore()

		private(set) var needsSetup: Bool

		/// Set by `TanukiRootView`; fires whenever `needsSetup` changes so the
		/// setup cover can be presented/dismissed.
		var onNeedsSetupChange: ((Bool) -> Void)?

		private init() {
			needsSetup = InstanceManager.selected == nil
		}

		func setNeedsSetup(_ value: Bool) {
			needsSetup = value
			onNeedsSetupChange?(value)
		}

		func refresh() {
			setNeedsSetup(InstanceManager.selected == nil)
		}
	}
#else
	@MainActor
	final class SessionStore: ObservableObject {
		static let shared = SessionStore()

		@Published
		private(set) var needsSetup: Bool

		/// Set by `TanukiRootView` so the setup cover follows this value.
		var onNeedsSetupChange: ((Bool) -> Void)?

		private init() {
			needsSetup = InstanceManager.selected == nil
		}

		func setNeedsSetup(_ value: Bool) {
			needsSetup = value
			onNeedsSetupChange?(value)
		}

		func refresh() {
			setNeedsSetup(InstanceManager.selected == nil)
		}
	}
#endif
