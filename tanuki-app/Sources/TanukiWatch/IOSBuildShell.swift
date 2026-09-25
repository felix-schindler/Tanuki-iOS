// `os(iOS)` and not `canImport(SwiftUI)`: the Android SDK reports SwiftUI as
// importable, but importing it there fails on a missing `CJNI` module.
#if os(iOS)
	import SwiftUI

	/// Entry point for the iOS build of this watch app target.
	///
	/// `skip app launch` builds the whole Xcode project with `-sdk
	/// iphonesimulator`, which overrides `SDKROOT` and forces the iOS SDK onto
	/// every target — including this watchOS one. The real app is watchOS-only
	/// (see `TanukiWatchApp`), so without an entry point here the resulting iOS
	/// shell fails to link ("Undefined symbols: _main") and takes the Android
	/// launch down with it. The shell is never installed anywhere; it only has
	/// to build.
	@main
	struct WatchAppIOSBuildShell: App {
		var body: some Scene {
			WindowGroup {
				EmptyView()
			}
		}
	}
#endif
