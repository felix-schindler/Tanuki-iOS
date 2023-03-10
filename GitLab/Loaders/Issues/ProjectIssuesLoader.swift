//
//  SingleProjectIssuesView.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct ProjectIssuesLoader: View {
	@State var id: Int
	@State var showNewIssue: Bool = false
	@State var showFilter: Bool = false
	
	@State var issues: [Issue]? = nil
	@State var noConnection: Bool = false
	
	@State var type = 0
	
	var body: some View {
		VStack {
			if (issues != nil) {
				IssueListView(issues: issues!, updateFunction: getIssues)
					.toolbar {
						ToolbarItemGroup(placement: .navigationBarTrailing) {
							Button(action: {showFilter = true}) {
								Image(systemName: "line.3.horizontal.decrease.circle")
							}
							Button(action: {showNewIssue = true}) {
								Image(systemName: "plus.circle")
							}
						}
					}.sheet(isPresented: $showNewIssue) {
						NewIssueView(id: id)
					}.sheet(isPresented: $showFilter) {
						Picker("Issue state", selection: $type) {
							Text("Open").tag(0)
							Text("Closed").tag(1)
							Text("All").tag(2)
						}.pickerStyle(WheelPickerStyle())
						Button("Apply") {
							Task.init {
								showFilter = false
								await getIssues()
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
				await getIssues()
			}
		}.navigationTitle("Issues")
	}
	
	private func getIssues() async -> Void {
		var filter = ["with_labels_details": "true", "sort": "desc", "order_by": "created_at"];
		
		if (type == 0) {
			filter["state"] = "opened"
		} else if (type == 1) {
			filter["state"] = "closed"
			filter["order_by"] = "updated_at"
		}
		
		issues = nil
		issues = await API.get(type: [Issue].self, endpoint: "projects/\(id)/issues", query: filter)
		noConnection = (issues == nil)
	}
}

struct ProjectIssuesLoader_Previews: PreviewProvider {
	static var previews: some View {
		ProjectIssuesLoader(id: Int(0))
	}
}
