//
//  ProjectsMemberView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

private enum Filter {
	case membership, owner
}

struct MemberProjectsLoader: View {
	@State private var showFilter: Bool = false
	@State private var filter: Filter = Filter.membership
	
	@State private var projects: [Project]? = nil
	@State private var noConnection: Bool = false
	
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
						Picker("Project access", selection: $filter) {
							Text("Membership").tag(Filter.membership)
							Text("Owner").tag(Filter.owner)
						}.pickerStyle(WheelPickerStyle())
						Button("Apply") {
							Task.init {
								showFilter = false
								await getProjects()
							}
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
				await getProjects()
			}
		}.navigationTitle("Projects")
	}
	
	private func getProjects() async -> Void {
		projects = nil
		noConnection = false
		
		var filters: Dictionary<String, String> = ["order_by": "last_activity_at"]
		if (filter == Filter.membership) {
			filters["membership"] = "true"
		} else if (filter == Filter.owner) {
			filters["owned"] = "true"
		}
		
		projects = await API.get(type: [Project].self, endpoint: "projects", query: filters)
		noConnection = (projects == nil)
	}
}

struct MemberProjectsLoader_Previews: PreviewProvider {
	static var previews: some View {
		MemberProjectsLoader()
	}
}
