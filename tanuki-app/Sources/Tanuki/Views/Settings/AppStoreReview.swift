//
//  AppStoreReview.swift
//  Tanuki
//
//  Created by Felix Schindler on 18.02.26.
//

import SwiftUI
import StoreKit

@available(iOS 16.0, *)
struct AppStoreReview: View {
	@Environment(\.requestReview) var requestReview
	
    public var body: some View {
		Button("App Store Review", systemImage: "star") {
			requestReview()
		}
    }
}

#Preview {
	if #available(iOS 16.0, *) {
		AppStoreReview()
	} else {
		Text("Not available on this platform. Update to iOS 16 or later.")
	}
}
