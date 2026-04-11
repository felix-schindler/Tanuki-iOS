//
//  SetupView.swift
//  Tanuki
//
//  Created by Felix Schindler on 16.03.24.
//

import MarkdownUI
import SwiftHttp
import SwiftUI

struct SetupView: View {
	@Environment(\.openURL) private var openURL
	private var showSetup: Binding<Bool>

	/// For CSRF protection
	private let state: String
	private let codeVerifier: String
	private let codeChallenge: String

	public init(showSetup: Binding<Bool>) {
		self.showSetup = showSetup
		self.state = UUID().uuidString
		self.codeVerifier = Auth.generateCodeVerifier()
		self.codeChallenge = Auth.generateCodeChallenge(codeVerifier: self.codeVerifier)
	}

	public var body: some View {
		NavigationView {
			VStack {
				Spacer()

				HStack {
					if let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
						let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
						let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
						let lastIcon = iconFiles.last,
						let iconImage = UIImage(named: lastIcon)
					{
						Image(uiImage: iconImage)
							.resizable()
							.scaledToFit()
							.cornerRadius(15)
							.frame(maxWidth: 70, maxHeight: 70)
					}
					Text("Welcome to \n**Tanuki for GitLab**")
				}

				Spacer()

				Button(
					action: {
						let authURL = HttpUrl(
							host: "gitlab.com",
							path: ["oauth", "authorize"],
							query: [
								"client_id": Auth.clientID,
								"code_challenge": self.codeChallenge,
								"code_challenge_method": "S256",
								"redirect_uri": Auth.redirectUri,
								"response_type": "code",
								"scope": Auth.scope,
								"state": self.state,
							]
						)

						openURL(authURL.url)
					},
					label: {
						Text("Login with GitLab.com")
							.frame(maxWidth: .infinity)
					}
				)
				.tint(.accentColor)
				.buttonBorderShape(.capsule)
				.buttonStyle(.borderedProminent)
				.controlSize(.large)

				NavigationLink(
					destination: ConfigView(showSetup: showSetup),
					label: {
						Text("Self-Hosted instance")
							.frame(maxWidth: .infinity)
					}
				)
				.tint(.accentColor)
				.buttonBorderShape(.capsule)
				.buttonStyle(.bordered)
				.controlSize(.large)

				Spacer()
			}
			.padding()
			.textFieldStyle(.roundedBorder)
		}.onOpenURL { url in
			switch url.relativePath {
			case "/callback":
				let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
				let queryItems = components?.queryItems

				if let code = queryItems?.first(where: { $0.name == "code" })?.value,
					let state = queryItems?.first(where: { $0.name == "state" })?.value
				{
					print(code, state)

					if state == self.state {
						Task {
							do {
								let auth = try await API.req(
									type: oAuthToken.self,
									method: .post,
									endpoint: "oauth/token",
									body: [
										"client_id": Auth.clientID,
										"code": code,
										"grant_type": "authorization_code",
										"redirect_uri": Auth.redirectUri,
										"code_verifier": self.codeVerifier,
									],
									contentType: .formUrlEncoded,
									useBase: false
								)

								let instance = GitLabInstance(
									host: "gitlab.com",
									token: auth.accessToken,
									isOAuth: true
								)
								InstanceManager.add(instance)

								let user = try await API.get(
									type: RestAPIUser.self,
									endpoint: "user"
								)

								Notify.status(
									.success,
									"Welcome, \(user.username)",
									systemImage: "checkmark"
								)
								self.showSetup.wrappedValue = false
							} catch let error {
								print(error)
								Notify.status(
									.error, "Failed to log in",
									error.localizedDescription,
									systemImage: "xmark"
								)
							}
						}
					} else {
						Notify.status(
							.error,
							"Couldn't log in",
							"State mismatch",
							systemImage: "exclamationmark.triangle"
						)
					}
				} else {
					Notify.status(
						.error,
						"Couldn't log in",
						"Malformed URL",
						systemImage: "exclamationmark.triangle"
					)
				}
			default:
				Notify.status(
					.warning,
					"Can't handle URL", "You need to log in first",
					systemImage: "exclamationmark.triangle"
				)
			}
		}
	}
}

#Preview {
	SetupView(showSetup: .constant(true))
}
