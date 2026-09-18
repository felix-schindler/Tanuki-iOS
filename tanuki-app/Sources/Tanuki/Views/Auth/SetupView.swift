//
//  SetupView.swift
//  Tanuki
//
//  Created by Felix Schindler on 16.03.24.
//

//import MarkdownUI
import SwiftUI

#if SKIP_BRIDGE
	private typealias PlatformNavigationView = NavigationStack
#else
	private typealias PlatformNavigationView = NavigationView
#endif

struct SetupView: View {
	@Environment(\.openURL) var openURL

	public init() {
	}

	public var body: some View {
		PlatformNavigationView {
			VStack {
				Spacer()

				HStack {
					#if canImport(UIKit)
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
					#endif
					Text("Welcome to \n**Tanuki for GitLab**")
				}

				Spacer()

				Button(
					action: {
						let request = OAuthRequest.shared.begin()
						if let authURL = Auth.authorizeUrl(
							state: request.state,
							codeChallenge: request.codeChallenge
						) {
							logger.debug("oauth: authorize \(authURL.absoluteString)")
							openURL(authURL)
						}
					},
					label: {
						Text("Login with GitLab.com")
							.frame(maxWidth: .infinity)
					}
				)
				.tint(.accentColor)
				#if !SKIP_BRIDGE
					.buttonBorderShape(.capsule)
				#endif
				#if !SKIP_BRIDGE
					.buttonStyle(.borderedProminent)
				#endif
				#if !SKIP_BRIDGE
					.controlSize(.large)
				#endif

				NavigationLink(
					destination: ConfigView(showSetup: nil),
					label: {
						Text("Self-Hosted instance")
							.frame(maxWidth: .infinity)
					}
				)
				.tint(.accentColor)
				#if !SKIP_BRIDGE
					.buttonBorderShape(.capsule)
				#endif
				.buttonStyle(.bordered)
				#if !SKIP_BRIDGE
					.controlSize(.large)
				#endif

				Spacer()
			}
			.padding()
			.textFieldStyle(.roundedBorder)
		}
	}
}
