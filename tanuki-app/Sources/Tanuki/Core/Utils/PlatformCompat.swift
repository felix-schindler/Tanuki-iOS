//
//  PlatformCompat.swift
//  Tanuki
//
//  Compatibility shims for macOS builds (Swift Package) where iOS-only APIs are unavailable.
//

import SwiftUI

#if !canImport(UIKit) && !SKIP_BRIDGE

	// MARK: - Keyboard / text input shims

	public enum UIKeyboardTypeCompat {
		case `default`
		case asciiCapable
		case numbersAndPunctuation
		// swift-format-ignore
		case URL
		case numberPad
		case phonePad
		case namePhonePad
		case emailAddress
		case decimalPad
		case twitter
		case webSearch
		case asciiCapableNumberPad
	}

	// Alias so `.URL` / `.emailAddress` literals resolve even without UIKit.
	public typealias UIKeyboardType = UIKeyboardTypeCompat

	public struct TextInputAutocapitalizationCompat: Hashable, Sendable {
		nonisolated(unsafe) public static let never = TextInputAutocapitalizationCompat()
		nonisolated(unsafe) public static let words = TextInputAutocapitalizationCompat()
		nonisolated(unsafe) public static let sentences = TextInputAutocapitalizationCompat()
		nonisolated(unsafe) public static let characters = TextInputAutocapitalizationCompat()
	}
	public typealias TextInputAutocapitalization = TextInputAutocapitalizationCompat

	extension View {
		public func keyboardType(_ type: UIKeyboardType) -> some View { self }
		public func textInputAutocapitalization(_ type: TextInputAutocapitalization?) -> some View { self }
	}

	// MARK: - Navigation bar shims

	public enum NavigationBarTitleDisplayModeCompat {
		case automatic
		case inline
		case large
	}

	extension View {
		public func navigationBarTitleDisplayMode(_ mode: NavigationBarTitleDisplayModeCompat) -> some View { self }
		public func navigationBarTitle(_ title: String) -> some View { self }
		public func navigationBarTitle(_ title: Text) -> some View { self }
	}

	// MARK: - Toolbar placement shims

	extension ToolbarItemPlacement {
		public static var topBarLeading: ToolbarItemPlacement { .automatic }
		public static var topBarTrailing: ToolbarItemPlacement { .automatic }
	}

	// MARK: - fullScreenCover -> sheet fallback on macOS

	extension View {
		public func fullScreenCover(
			isPresented: Binding<Bool>,
			onDismiss: (() -> Void)? = nil,
			content: @escaping () -> some View
		) -> some View {
			sheet(isPresented: isPresented, onDismiss: onDismiss, content: content)
		}
	}

#endif

#if !canImport(UIKit) && canImport(AppKit) && !SKIP_BRIDGE
	import AppKit

	// UIImage alias for macOS
	public typealias UIImage = NSImage

	extension Image {
		public init(uiImage: NSImage) {
			self.init(nsImage: uiImage)
		}
	}
#endif

#if !canImport(UIKit) && !SKIP_BRIDGE
	// ListStyle fallback for `.grouped` which is unavailable on macOS.
	// We expose a no-op modifier that accepts `Any` so call sites compile.
	extension View {
		public func listStyleGroupedFallback() -> some View { self }
	}
#endif
