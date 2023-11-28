//
//  MemberGroupsLoader.swift
//  GitLab
//
//  Created by Felix Schindler on 24.01.22.
//

import SwiftUI

enum GroupOrder: String {
	case FIELD = "order_by"
	case name = "name",
			 path = "path",
			 id = "id",
			 similarity = "similarity"
}

struct GroupsLoader: View {
	@State var groups: [SmallGroup]? = nil
	@State var loadFailed: Bool = false
	
	@State var showFilter = false
	
	@State var search = ""
	@State var sort: ProjectSort = .asc
	@State var orderBy: GroupOrder = .name
	@State var owned = false
	@State var allAvailable = false
	
	var body: some View {
		List {
			if (groups != nil) {
				GroupListView(groups: groups!, updateFunction: getGroups)
			} else {
				if (loadFailed) {
					Text(Messages.failedToLoad)
				} else {
					ProgressView()
				}
			}
		}.refreshable {
			groups = await getGroups()
			loadFailed = (groups == nil)
		}	.searchable(text: $search)
			.onSubmit(of: .search) {
				Task {
					groups = await getGroups()
					loadFailed = (groups == nil)
				}
			}.onAppear {
				Task {
					groups = await getGroups()
					loadFailed = (groups == nil)
				}
			}.toolbar {
				Button(action: { showFilter = true }, label: {
					Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
				})
			}.sheet(isPresented: $showFilter) {
				Form {
					Section {
						if (!allAvailable) {
							Toggle("Owned", isOn: $owned)
						}
						if (!owned) {
							Toggle("All available", isOn: $allAvailable)
						}
					}
					
					Section {
						Picker("Order by", selection: $orderBy) {
							Text("Name").tag(GroupOrder.name)
							Text("Path").tag(GroupOrder.path)
							Text("ID").tag(GroupOrder.id)
							Text("Similarity").tag(GroupOrder.similarity)
						}
						
						Picker("Sort", selection: $sort) {
							Text("Ascending").tag(ProjectSort.asc)
							Text("Descending").tag(ProjectSort.desc)
						}
					}
					
					AsyncButton("Apply", action: {
						groups = await getGroups()
						loadFailed = (groups == nil)
						showFilter = false
					})
				}
			}.navigationTitle("Groups")
	}
	
	private func getGroups() async -> [SmallGroup]? {
		var query: Dictionary<String, String> = [:]
		
		if (!search.isEmpty) {
			query["search"] = search
		}
		
		if (orderBy != .name) {
			query["order_by"] = orderBy.rawValue
		}
		
		if (sort != .asc) {
			query["sort"] = sort.rawValue
		}
		
		if (owned != false) {
			query["owned"] = String(owned)
		}
		
		if (allAvailable != false) {
			query["all_available"] = String(allAvailable)
		}
		
		return await API.get(type: [SmallGroup].self, endpoint: "groups", query: query)
	}
}

struct MemberGroupsLoader_Previews: PreviewProvider {
	static var previews: some View {
		GroupsLoader()
	}
}
