//
//  ProjectsMemberView.swift
//  GitLab
//
//  Created by Felix Schindler on 30.10.21.
//

import SwiftUI

struct MemberProjectsLoader: View {
	@State var showFilter: Bool = false
	@State var filter: Int = 0
	
	@State var projects: [Project]? = nil
	@State var noConnection: Bool = false
	
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
						Picker("Issue state", selection: $filter) {
							Text("All").tag(0)
							Text("Owner").tag(1)
						}.pickerStyle(WheelPickerStyle())
						Button("Apply") {
							Task.init {
								showFilter = false
								await getProjects()
							}
						}
					}
			} else {
				if (noConnection) {
					Text("Failed to load, please check your internet connection and your token")
				} else {
					Spacer()
					ProgressView("Loading")
					Spacer()
				}
			}
		}.onAppear {
			Task.init {
				await getProjects()
			}
		}.navigationTitle("Projects")
	}
	
	private func getProjects() async -> Void {
		projects = await API.get(type: [Project].self, endpoint: "projects", query: ["membership": "true", "order_by": "last_activity_at"])
		noConnection = projects == nil
	}
}

struct MemberProjectsLoader_Previews: PreviewProvider {
	static var previews: some View {
		MemberProjectsLoader()
	}
}
