#if os(watchOS)
	import SwiftUI

	@main
	struct TanukiWatchApp: App {
		init() {
			WatchSync.shared.activate()
		}

		var body: some Scene {
			WindowGroup {
				ContentView()
			}
		}
	}
#endif
