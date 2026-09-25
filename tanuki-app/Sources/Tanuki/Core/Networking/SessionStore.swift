//
//  SessionStore.swift
//  Tanuki
//
//  Created by Felix Schindler on 28.04.26.
//

import SwiftUI

/// On Android the store cannot be an `ObservableObject`, so a plain class could not drive
/// SwiftUI presentation state: reading `needsSetup` in a view body would create no dependency.
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

	func refresh() {
		needsSetup = InstanceManager.selected == nil
		onNeedsSetupChange?(needsSetup)
	}
}
