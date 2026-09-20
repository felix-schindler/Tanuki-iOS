//
//  Auth.swift
//  Tanuki
//
//  Created by Felix Schindler on 03.10.25.
//

import Foundation
import SwiftUI

#if canImport(CryptoKit)
	import CryptoKit
#endif

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
		let verifierData = Data(codeVerifier.utf8)

		#if SKIP_BRIDGE
			let digest = SHA256Hash.hash(verifierData)
		#else
			let digest = Data(SHA256.hash(data: verifierData))
		#endif

		return digest.base64EncodedString()
			.replacingOccurrences(of: "+", with: "-")
			.replacingOccurrences(of: "/", with: "_")
			.replacingOccurrences(of: "=", with: "")
	}

	public static func authorizeUrl(state: String, codeChallenge: String) -> URL? {
		var components = URLComponents()
		components.scheme = "https"
		components.host = "gitlab.com"
		components.path = "/oauth/authorize"
		components.queryItems = [
			URLQueryItem(name: "client_id", value: clientID),
			URLQueryItem(name: "code_challenge", value: codeChallenge),
			URLQueryItem(name: "code_challenge_method", value: "S256"),
			URLQueryItem(name: "redirect_uri", value: redirectUri),
			URLQueryItem(name: "response_type", value: "code"),
			URLQueryItem(name: "scope", value: scope),
			URLQueryItem(name: "state", value: state),
		]
		return components.url
	}

	@MainActor
	public static func handleCallback(_ url: URL) async {
		guard url.relativePath == "/callback" else {
			Notify.status(
				.warning,
				"Can't handle URL", "You need to log in first",
				systemImage: "exclamationmark.triangle"
			)
			return
		}

		guard let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems,
			let code = queryItems.first(where: { $0.name == "code" })?.value,
			let state = queryItems.first(where: { $0.name == "state" })?.value
		else {
			Notify.status(
				.error,
				"Couldn't log in", "Malformed URL",
				systemImage: "exclamationmark.triangle"
			)
			return
		}

		guard let codeVerifier = OAuthRequest.shared.takeVerifier(for: state) else {
			Notify.status(
				.error,
				"Couldn't log in", "State mismatch",
				systemImage: "exclamationmark.triangle"
			)
			return
		}

		do {
			let auth = try await API.req(
				type: OAuthToken.self,
				method: .post,
				endpoint: "oauth/token",
				body: [
					"client_id": clientID,
					"code": code,
					"grant_type": "authorization_code",
					"redirect_uri": redirectUri,
					"code_verifier": codeVerifier,
				],
				contentType: .formUrlEncoded,
				useBase: false
			)

			try await login(
				instance: GitLabInstance(
					host: "gitlab.com",
					token: auth.accessToken,
					isOAuth: true
				))
		} catch let error {
			Notify.status(
				.error, "Failed to log in",
				error.localizedDescription,
				systemImage: "xmark"
			)
		}
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
			let user = try await currentUser(afterOAuthLogin: instance.isOAuth)

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
				if !InstanceManager.instances.contains(previousInstance) {
					InstanceManager.add(previousInstance)
				}
				InstanceManager.select(previousInstance)
				try await resetSessionCaches()
			}
			SessionStore.shared.refresh()
			throw error
		}
	}

	@MainActor
	private static func currentUser(afterOAuthLogin isOAuth: Bool) async throws -> RestAPIUser {
		let attempts = isOAuth ? 4 : 1

		for attempt in 1...attempts {
			do {
				return try await API.get(type: RestAPIUser.self, endpoint: "user")
			} catch let error as APIError {
				guard case .http(let status, _) = error, status == 401, attempt < attempts else {
					throw error
				}
				logger.warning("oauth: token not visible to the API yet, retry \(attempt)/\(attempts - 1)")
				try? await Task.sleep(for: .milliseconds(700))
			}
		}

		throw APIError.http(status: 401, message: "Unauthorized")
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
		URLCache.avatar.removeAllCachedResponses()
		Network.shared.resetApolloClient()
		try await Network.shared.apollo.store.clearCache()
	}
}

@MainActor
final class OAuthRequest {
	static let shared = OAuthRequest()

	private static let stateKey = "oauthPendingState"
	private static let verifierKey = "oauthPendingCodeVerifier"

	private let defaults = UserDefaults.standard

	private init() {
	}

	func begin() -> (state: String, codeChallenge: String) {
		let state = UUID().uuidString
		let codeVerifier = Auth.generateCodeVerifier()

		defaults.set(state, forKey: Self.stateKey)
		defaults.set(codeVerifier, forKey: Self.verifierKey)

		return (state, Auth.generateCodeChallenge(codeVerifier: codeVerifier))
	}

	func takeVerifier(for state: String) -> String? {
		guard state.isNotEmpty, state == defaults.string(forKey: Self.stateKey) else {
			return nil
		}

		let verifier = defaults.string(forKey: Self.verifierKey)
		clear()
		return verifier
	}

	func clear() {
		defaults.removeObject(forKey: Self.stateKey)
		defaults.removeObject(forKey: Self.verifierKey)
	}
}
