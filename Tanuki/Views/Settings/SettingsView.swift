//
//  SettingsView.swift
//  Tanuki
//
//  Created by Felix Schindler on 23.11.25.
//

import SwiftUI

struct SettingsView: View {
	public var body: some View {
		List {
			Section {
				VStack(alignment: .leading) {
					Image(systemName: "gear")
						.resizable()
						.scaledToFill()
						.foregroundStyle(.white)
						.frame(width: 50, height: 50)
						.padding(5)
						.background(.gray)
						.clipShape(RoundedRectangle(cornerRadius: 15.0))
						.padding(.bottom, 10)
					Text("Settings")
						.font(.title2.bold())
						.padding(.bottom, 1)
					Text("Clear caches, manage cookies, manage clipboard access, or submit feedback.")
						.font(.callout)
						.foregroundStyle(.secondary)
				}
			}

			Section {
				NavigationLink(destination: CacheView()) {
					Label("Cache", systemImage: "internaldrive")
				}
				NavigationLink(destination: CookiesView()) {
					Label(
						title: { Text("Cookies") },
						icon: {
							Image("cookie.symbols")
								.resizable()
								.scaledToFit()
						})
				}
				NavigationLink(destination: InstancesView()) {
					Label("Instances", systemImage: "server.rack")
				}
				// NavigationLink(destination: ClipboardAccess()) {
				// 	Label("Clipboard URL", systemImage: "arrow.right.page.on.clipboard")
				// }
			}

			Section {
				NavigationLink(destination: FeedbackView()) {
					Label("Feedback", systemImage: "exclamationmark.bubble")
				}
				if #available(iOS 16.0, *) {
					AppStoreReview()
				}
			}
		}
	}
}

#Preview {
	NavigationView {
		SettingsView()
	}
}
