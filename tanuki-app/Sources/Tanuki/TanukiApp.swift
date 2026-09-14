//
//  TanukiApp.swift (GitLabApp.swift)
//  Tanuki (GitLab)
//
//  Created by Felix Schindler on 30.10.21.
//  Rewritten by Felix Schindler on 26.02.24.
//  Rewritten by Felix Schindler again on 11.04.26 when moving to Skip.
//

import Foundation
import SkipFuse
import SwiftUI

/// A logger for the Tanuki module.
let logger: Logger = Logger(subsystem: "de.schindlerfelix.GitLab", category: "Tanuki")

/// The shared top-level view for the app, loaded from the platform-specific App delegates below.
///
/// The default implementation merely loads the `ContentView` for the app and logs a message.
/* SKIP @bridge */public struct TanukiRootView: View {
	/// Presentation state for the setup cover.
	///
	/// This has to be plain view state (and a *bridged* one, so the generated Kotlin side gets
	/// a state box): the Android `SessionStore` cannot be an observable object, so reading a
	/// property off it in the body would never trigger recomposition. `SessionStore` reports
	/// changes through `onNeedsSetupChange`, wired up below.
	@State var needsSetup = SessionStore.shared.needsSetup

	/* SKIP @bridge */public init() {
		logger.info("Skip app logs are viewable in the Xcode console for iOS; Android logs can be viewed in Studio or using adb logcat")

		InstanceManager.migrate()
		WatchSync.shared.activate()
	}

	public var body: some View {
		ContentView()
			.fullScreenCover(isPresented: $needsSetup) {
				SetupView()
			}
			.onAppear {
				SessionStore.shared.onNeedsSetupChange = { value in
					needsSetup = value
				}
			}
	}
}

/// Global application delegate functions.
///
/// These functions can update a shared observable object to communicate app state changes to interested views.
/* SKIP @bridge */public final class TanukiAppDelegate: Sendable {
	/* SKIP @bridge */public static let shared = TanukiAppDelegate()

	private init() {
	}

	/* SKIP @bridge */public func onInit() {
		logger.debug("onInit")
	}

	/* SKIP @bridge */public func onLaunch() {
		logger.debug("onLaunch")
	}

	/* SKIP @bridge */public func onResume() {
		logger.debug("onResume")
	}

	/* SKIP @bridge */public func onPause() {
		logger.debug("onPause")
	}

	/* SKIP @bridge */public func onStop() {
		logger.debug("onStop")
	}

	/* SKIP @bridge */public func onDestroy() {
		logger.debug("onDestroy")
	}

	/* SKIP @bridge */public func onLowMemory() {
		logger.debug("onLowMemory")
	}
}
