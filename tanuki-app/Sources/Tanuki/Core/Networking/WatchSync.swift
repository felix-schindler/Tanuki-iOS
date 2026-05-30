//
//  WatchSync.swift
//  Tanuki
//
//  Created by Felix Schindler on 06.05.26.
//

#if canImport(WatchConnectivity)
	import Foundation
	import WatchConnectivity

	@MainActor
	final class WatchSync: NSObject, WCSessionDelegate {
		static let shared = WatchSync()
		private let encoder = JSONEncoder()
		private var didActivate = false

		func activate() {
			guard WCSession.isSupported() else { return }
			let session = WCSession.default
			session.delegate = self
			session.activate()
		}

		func pushInstances() {
			guard WCSession.isSupported() else { return }
			let session = WCSession.default
			if !didActivate {
				activate()
			}

			guard let data = try? encoder.encode(InstanceManager.instances) else { return }
			var context: [String: Any] = [
				"instances": data
			]
			if let selectedId = InstanceManager.selectedId {
				context["selectedId"] = selectedId
			}

			try? session.updateApplicationContext(context)
		}

		nonisolated func session(
			_ session: WCSession,
			activationDidCompleteWith activationState: WCSessionActivationState,
			error: Error?
		) {
			Task { @MainActor in
				didActivate = activationState == .activated
				if didActivate {
					pushInstances()
				}
			}
		}

		nonisolated func sessionDidBecomeInactive(_ session: WCSession) {}

		nonisolated func sessionDidDeactivate(_ session: WCSession) {
			session.activate()
		}
	}

#endif
