//
//  Auth.swift
//  Tanuki
//
//  Created by Felix Schindler on 03.10.25.
//

import CryptoKit
import Foundation
import SwiftUI

class Auth {
	public static let clientID = "9ee458e1f3cca37c7d9c6651da1caa5d242ce9988e08471e7cba278cbe2eced2"
	public static let scope = "api+read_repository"
	public static let redirectUri = "tanuki://oauth/callback"

	public static func generateCodeVerifier() -> String {
		let length = Int.random(in: 43...128)
		let characters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
		var result = ""
		for _ in 0..<length {
			result.append(characters.randomElement()!)
		}
		return result
	}

	public static func generateCodeChallenge(codeVerifier: String) -> String {
		let data = Data(codeVerifier.utf8)
		let digest = SHA256.hash(data: data)
		let sha256Data = Data(digest)

		let base64 = sha256Data.base64EncodedString()
			.replacingOccurrences(of: "+", with: "-")
			.replacingOccurrences(of: "/", with: "_")
			.replacingOccurrences(of: "=", with: "")

		return base64
	}

	@MainActor
	public static func login(
		instance: GitLabInstance,
		showSetup: Binding<Bool>? = nil,
		dismiss: DismissAction? = nil
	) async throws {
		let previousInstance = InstanceManager.selected
		InstanceManager.add(instance)
		try await resetSessionCaches()

		do {
			let user = try await API.get(
				type: RestAPIUser.self,
				endpoint: "user"
			)

			Notify.status(
				.success,
				"Welcome, \(user.username)",
				systemImage: "checkmark"
			)
			showSetup?.wrappedValue = false
			dismiss?()
			SessionStore.shared.refresh()
		} catch {
			InstanceManager.remove(instance)
			if let previousInstance {
				InstanceManager.select(previousInstance)
				try await resetSessionCaches()
			}
			SessionStore.shared.refresh()
			throw error
		}
	}

	@MainActor
	public static func logout(showSetup: Binding<Bool>? = nil) async {
		if let current = InstanceManager.selected {
			InstanceManager.remove(current)
		}

		do {
			try await resetSessionCaches()
			Notify.status(.success, "Logged out")

			if InstanceManager.selected == nil {
				showSetup?.wrappedValue = true
			}
			SessionStore.shared.refresh()
		} catch let error {
			Notify.status(
				.error,
				"Failed to log out",
				error.localizedDescription
			)
		}
	}

	@MainActor
	public static func switchInstance(to instance: GitLabInstance) async {
		InstanceManager.select(instance)

		do {
			try await resetSessionCaches()
			let user = try await API.get(
				type: RestAPIUser.self,
				endpoint: "user"
			)
			Notify.status(
				.success,
				"Switched to \(user.username)",
				systemImage: "checkmark"
			)
			SessionStore.shared.refresh()
		} catch let error {
			Notify.status(
				.error,
				"Failed to switch instance",
				error.localizedDescription,
				systemImage: "xmark"
			)
		}
	}

	@MainActor
	private static func resetSessionCaches() async throws {
		URLCache.shared.removeAllCachedResponses()
		URLCache.avatarCache.removeAllCachedResponses()
		Network.shared.resetApolloClient()
		try await Network.shared.apollo.store.clearCache()
	}
}
