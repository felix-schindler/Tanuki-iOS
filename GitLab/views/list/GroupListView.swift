//
//  GroupListView.swift
//  GitLab
//
//  Created by Felix Schindler on 24.01.22.
//

import SwiftUI
import MarkdownUI

struct GroupListView: View {
	@State var groups: [SmallGroup]
	@State var updateFunction: () async -> [SmallGroup]?
	
	var body: some View {
		if (groups.isEmpty) {
			Text("There are no groups")
		} else {
			ForEach(groups, id: \.id) { group in
				SmallGroupView(group: group)
			}
		}
	}
}

struct GroupListView_Previews: PreviewProvider {
	static var previews: some View {
		GroupListView(groups: [], updateFunction: { nil })
	}
}
