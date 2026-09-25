//
//  CachedRemoteImage.swift
//  GitLab
//
//  Created by Felix Schindler on 25.09.26.
//

// Darwin-only: `CachedAsyncImage` is a SwiftUI package that cannot be built for
// Android, so it is declared with `condition: .when(platforms: [.iOS, .macOS])`
// in Package.swift and Android renders a plain `AsyncImage` instead.
//
// The whole file stays inside the `canImport` check — skipping it also skips its
// imports, while a conditional `import CachedAsyncImage` next to a bridged type
// is copied verbatim into the generated `<Name>_Bridge.swift` and breaks the
// Android build.
#if canImport(CachedAsyncImage)
	import CachedAsyncImage
	import SwiftUI

	/// `AsyncImage` that reads from and writes to the given `URLCache`.
	struct CachedRemoteImage<Content: View>: View {
		let url: URL
		let urlCache: URLCache
		@ViewBuilder let content: (AsyncImagePhase) -> Content

		var body: some View {
			CachedAsyncImage(url: self.url, urlCache: self.urlCache, content: self.content)
		}
	}
#endif
