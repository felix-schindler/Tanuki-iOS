//
//  ScrollDismissIfAvailable.swift
//  Tanuki
//
//  Created by Felix Schindler on 21.09.25.
//

import SwiftUI

struct ScrollDismissIfAvailable: ViewModifier {
	func body(content: Content) -> some View {
		if #available(iOS 16.0, *) {
			content.scrollDismissesKeyboard(.interactively)
		} else {
			content
		}
	}
}

struct PresentationDetendsIfAvailable: ViewModifier {
	func body(content: Content) -> some View {
		if #available(iOS 16.0, *) {
			content.presentationDetents([.fraction(0.2), .medium])
		} else {
			content
		}
	}
}

struct LabelSpacingIfAvailable: ViewModifier {
	func body(content: Content) -> some View {
		if #available(iOS 26.0, macOS 26.0, *) {
			content.labelIconToTitleSpacing(5)
		} else {
			content
		}
	}
}
