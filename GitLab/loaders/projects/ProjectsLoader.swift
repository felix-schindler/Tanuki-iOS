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
	@State private var loadFailed: Bool = false
	
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
	
	@State var userId = 0
	
	var body: some View {
		List {
			if (projects != nil) {
				ProjectListView(projects: projects!)
			} else if (loadFailed) {
				Text(Messages.failedToLoad)
			} else {
				ProgressView()
			}
		}.toolbar {
			RoundIconButton("Show Filters", icon: "line.3.horizontal.decrease") {
				showFilter = true
			}
		}.refreshable {
			if let temp = await getProjects() {
				projects = temp
			}
		}.searchable(text: $search)
			.onSubmit(of: .search) {
				Task {
					projects = nil
					projects = await getProjects()
					loadFailed = (projects == nil)
				}
			}.onAppear {
				Task {
					projects = await getProjects()
					loadFailed = (projects == nil)
				}
			}.sheet(isPresented: $showFilter) {
				VStack {
					Form {
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
								Label("Ascending", systemImage: "increase.indent")
									.tag(ProjectSort.asc)
								Label("Descending", systemImage: "decrease.indent")
									.tag(ProjectSort.desc)
							}
						}
						
						Section {
							Picker("Visibility", selection: $visibility) {
								Text("All")
									.tag(ProjectVisibility.all)
								Label("Public", systemImage: "globe")
									.tag(ProjectVisibility.public)
								Label("Internal", systemImage: "shield.lefthalf.filled")
									.tag(ProjectVisibility.internal)
								Label("Private", systemImage: "lock")
									.tag(ProjectVisibility.private)
							}
						}
					}
					
					VStack {
						AsyncButton(action: {
							projects = nil
							projects = await getProjects()
							loadFailed = (projects == nil)
							showFilter = false
						}, label: {
							Text("Apply")
								.frame(maxWidth: .infinity)
						}).tint(.accentColor)
							.controlSize(.large)
							.buttonStyle(.bordered)
						
						Button(role: .cancel,
							   action: {
							showFilter = false
						}, label: {
							Text("Cancel")
								.frame(maxWidth: .infinity)
						}).foregroundStyle(.secondary)
							.buttonStyle(.bordered)
							.controlSize(.large)
					}.padding()
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
		
		var endpoint = "projects"
		if (userId != 0) {
			endpoint = "users/\(userId)/projects"
		}
		return await API.get(type: [Project].self, endpoint: endpoint, query: filters)
	}
}

#Preview {
	NavigationStack {
		ProjectsLoader()
	}
}
