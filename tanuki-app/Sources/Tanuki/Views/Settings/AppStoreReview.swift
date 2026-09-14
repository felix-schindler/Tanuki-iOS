//
//  AppStoreReview.swift
//  Tanuki
//
//  Created by Felix Schindler on 18.02.26.
//

#if canImport(StoreKit)
	import StoreKit
	import SwiftUI

	@available(iOS 16.0, *)
	struct AppStoreReview: View {
		@Environment(\.requestReview) var requestReview

		public var body: some View {
			Button("App Store Review", systemImage: "star") {
				requestReview()
			}
		}
	}
#endif
