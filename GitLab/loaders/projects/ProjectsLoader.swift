//
//	ProjectsLoader.swift (renamed 20.03.23)
//  ProjectsMemberView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct ProjectsLoader: View {
	@State private var showFilter: Bool = false
	
	@State private var projects: [Project]? = nil
	@State private var noConnection: Bool = false
	
	@State var search: String = ""
	
	// Filter
	@State var membership = false
	@State var owned = false
	@State var starred = false
	@State var archived = false
	@State var imported = false
	
	@State var orderBy: ProjectOrder = .createdAt
	@State var sort: ProjectSort = .desc
	
	@State var visibility: ProjectVisibility = .all

	var body: some View {
		VStack {
			if (projects != nil) {
				ProjectListView(projects: projects!, updateFunction: getProjects)
					.toolbar {
						ToolbarItemGroup(placement: .navigationBarTrailing) {
							Button(action: {showFilter = true}) {
								Image(systemName: "line.3.horizontal.decrease.circle")
							}
						}
					}.sheet(isPresented: $showFilter) {
						List {
							Section {
								Toggle(isOn: $membership) {
									Text("Member")
								}
								Toggle(isOn: $owned) {
									Text("Owner")
								}
								Toggle(isOn: $starred) {
									Text("Starred")
								}
								Toggle(isOn: $imported) {
									Text("Imported")
								}
								Toggle(isOn: $archived) {
									Text("Archived")
								}
							}
							
							Section {
								Picker("Order by", selection: $orderBy) {
									Text("ID").tag(ProjectOrder.id)
									Text("Name").tag(ProjectOrder.name)
									Text("Path").tag(ProjectOrder.path)
									Text("Created at").tag(ProjectOrder.createdAt)
									Text("Updated at").tag(ProjectOrder.updatedAt)
									Text("Last activity at").tag(ProjectOrder.lastActivityAt)
									Text("Similarity").tag(ProjectOrder.similarity)
								}
								
								Picker("Sort", selection: $sort) {
									Text("Ascending").tag(ProjectSort.asc)
									Text("Descending").tag(ProjectSort.desc)
								}
							}
							
							Section {
								Picker("Visibility", selection: $visibility) {
									Text("All").tag(ProjectVisibility.all)
									Text("Public").tag(ProjectVisibility.public)
									Text("Internal").tag(ProjectVisibility.internal)
									Text("Private").tag(ProjectVisibility.private)
								}
							}
							
							AsyncButton(action: {
								projects = nil
								projects = await getProjects()
								noConnection = (projects == nil)
								showFilter = false
							}, label: {
								Text("Apply")
							})
						}
					}.searchable(text: $search)
					.onSubmit(of: .search) {
						Task.init {
							projects = nil
							projects = await getProjects()
							noConnection = (projects == nil)
						}
					}
			} else if (noConnection) {
				Text("Failed to load, please check your internet connection and your token")
			} else {
				Spacer()
				ProgressView("Loading")
				Spacer()
			}
		}.onAppear {
			Task.init {
				projects = await getProjects()
				noConnection = (projects == nil)
			}
		}.navigationTitle("Projects")
	}
	
	private func getProjects() async -> [Project]? {
		var filters: Dictionary<String, String> = [:]
		
		let _search = search.trim()
		if (_search != "") {
			filters["search"] = _search
		}
		
		filters["membership"] = String(membership)
		filters["owned"] = String(owned)
		filters["starred"] = String(starred)
		filters["archived"] = String(archived)
		filters["imported"] = String(imported)
		filters[ProjectOrder.NAME.rawValue] = orderBy.rawValue
		filters[ProjectSort.NAME.rawValue] = sort.rawValue
		
		if (visibility != .all) {
			filters[ProjectVisibility.NAME.rawValue] = visibility.rawValue
		}

		return await API.get(type: [Project].self, endpoint: "projects", query: filters)
	}
}

struct ProjectsLoader_Previews: PreviewProvider {
	static var previews: some View {
		ProjectsLoader()
	}
}
