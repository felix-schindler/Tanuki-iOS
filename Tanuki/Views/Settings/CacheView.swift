//
//  SettingsView.swift
//  Tanuki
//
//  Created by Felix Schindler on 03.10.25.
//

import SwiftUI

struct CacheView: View {
	private let formatter: ByteCountFormatter

	@State private var urlMemoryUsage = URLCache.shared.currentMemoryUsage
	@State private var urlDiskUsage = URLCache.shared.currentMemoryUsage

	@State private var avatarMemoryUsage = URLCache.avatarCache.currentMemoryUsage
	@State private var avatarDiskUsage = URLCache.avatarCache.currentMemoryUsage

	public init() {
		self.formatter = ByteCountFormatter()
		self.formatter.allowedUnits = [.useKB, .useMB, .useGB]
		self.formatter.countStyle = .file
	}

	private func formatBytes(_ bytes: Int) -> String {
		return formatter.string(fromByteCount: Int64(bytes))
	}

	public var body: some View {
		Form {
			Section("URL cache") {
				Text("In memory: \(formatBytes(urlMemoryUsage))")
				Text("On disk: \(formatBytes(urlDiskUsage))")
				Button("Clear cache", systemImage: "trash", role: .destructive) {
					URLCache.shared.removeAllCachedResponses()
					urlMemoryUsage = URLCache.shared.currentMemoryUsage
					urlDiskUsage = URLCache.shared.currentMemoryUsage
				}
			}

			Section("Avatar cache") {
				Text("In memory \(formatBytes(avatarMemoryUsage))")
				Text("On disk \(formatBytes(avatarDiskUsage))")

				Button("Clear cache", systemImage: "trash", role: .destructive) {
					URLCache.avatarCache.removeAllCachedResponses()
					avatarMemoryUsage = URLCache.avatarCache.currentMemoryUsage
					avatarDiskUsage = URLCache.avatarCache.currentMemoryUsage
				}
			}

			Section("GraphQL cache") {
				Text(
					"Due to GraphQL limitations, the actual size of the cache is unknown. If you feel this app is taking up too much storage, consider clearing this cache."
				)
				AsyncButton("Clear cache", systemImage: "trash", role: .destructive) {
					do {
						try await Network.shared.apollo.store.clearCache()
						Notify.status(.success, "Cleared cache", systemImage: "checkmark")
					} catch let error {
						Notify.status(
							.error, "Failed to clear cache", error.localizedDescription,
							systemImage: "xmark")
					}
				}
			}
		}.navigationTitle("Caches")
	}
}

#Preview {
	SettingsView()
}
