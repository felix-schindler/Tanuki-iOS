//
//  ProjectLanguagesLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 19.03.23.
//

import SwiftUI

struct ProjectLanguagesLoader: View {
	/// Project ID
	@State var id: Int
	
	@State var languages: Dictionary<String, Double>? = nil
	@State var loadFailed: Bool = false
	
	var body: some View {
		VStack {
			if (languages != nil) {
				LanguagesListView(languages: languages!)
			} else if (loadFailed) {
				Text("Failed to load, please check your internet connection and your token")
			} else {
				Spacer()
				ProgressView()
				Spacer()
			}
		}.onAppear {
			Task {
				languages = await getLanguages()
				loadFailed = (languages == nil)
			}
		}
	}
	
	private func getLanguages() async -> Dictionary<String, Double>? {
		return await API.get(type: Dictionary<String, Double>.self, endpoint: "projects/\(id)/languages")
	}
}

struct ProjectLanguagesLoader_Previews: PreviewProvider {
	static var previews: some View {
		ProjectLanguagesLoader(id: 33025310)
	}
}
