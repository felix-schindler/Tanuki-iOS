//
//  SingleProjectIssuesView.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct IssuesLoader: View {
	/// Project ID
	@State var id: Int = 0
	/// Group ID
	@State var groupId: Int = 0
	
	@State var showNewIssue: Bool = false
	@State var showFilter: Bool = false
	
	@State var issues: [Issue]? = nil
	@State var loadFailed: Bool = false
	
	// Search
	@State var search: String = ""
	
	// Filters
	@State var state: IssueState = .opened
	@State var sort: ProjectSort = .desc
	@State var orderBy: IssueOrder = .createdAt
	@State var type: IssueType = .all
	@State var confidential: Bool = false
	@State var dueDate: IssueDue = .all
	@State var scope: IssueScope = .all
	
	/// Title of a milestone
	@State var milestone: String?
	
	// @State var assignees
	// @State var author
	// @State var createdAfter
	// @State var createdBefore
	// @State var iids
	// @State var labels
	// @State var not
	// @State var updatedAfter
	// @State var updatedBefore
	
	var body: some View {
		List {
			if (issues != nil) {
				if (issues!.isEmpty) {
					Text("You're all caught up, there are no issues! 🚀")
				} else {
					ForEach(issues!, id: \.id) { issue in
						SmallIIssueView(issue: issue, showRef: (id == 0))
					}
				}
			} else {
				if (loadFailed) {
					Text(Messages.failedToLoad)
				} else {
					ProgressView()
				}
			}
		}.refreshable {
			issues = await getIssues()
			loadFailed = (issues == nil)
		}.onAppear {
			Task {
				issues = await getIssues()
				loadFailed = (issues == nil)
			}
		}.searchable(text: $search)
			.onSubmit(of: .search) {
				Task {
					issues = await getIssues()
					loadFailed = (issues == nil)
				}
			}.toolbar {
				Button(action: {showFilter = true}) {
					Image(systemName: "line.3.horizontal.decrease.circle")
				}
				if (id != 0) {
					Button(action: {showNewIssue = true}) {
						Image(systemName: "plus.circle")
					}
				}
			}.sheet(isPresented: $showNewIssue) {
				NewIssueView(id: id)
			}.sheet(isPresented: $showFilter) {
				Form {
					Section {
						Picker("State", selection: $state) {
							Text("Open").tag(IssueState.opened)
							Text("Closed").tag(IssueState.closed)
							Text("All").tag(IssueState.all)
						}
						
						Picker("Sort", selection: $sort) {
							Text("Ascending").tag(ProjectSort.asc)
							Text("Descending").tag(ProjectSort.desc)
						}
						
						Picker("Order by", selection: $orderBy) {
							Text("Created at").tag(IssueOrder.createdAt)
							Text("Due date").tag(IssueOrder.dueDate)
							Text("Label priority").tag(IssueOrder.labelPriority)
							Text("Milestone due").tag(IssueOrder.milestoneDue)
							Text("Popularity").tag(IssueOrder.popularity)
							Text("Priority").tag(IssueOrder.priority)
							Text("Relative position").tag(IssueOrder.relativePosition)
							Text("Title").tag(IssueOrder.title)
							Text("Updated at").tag(IssueOrder.updatedAt)
							Text("Weight").tag(IssueOrder.weight)
						}
					}
					
					Section {
						Picker("Due", selection: $dueDate) {
							Text("All").tag(IssueDue.all)
							Text("No due date").tag(IssueDue.noDueDate)
							Text("Any").tag(IssueDue.any)
							Text("Today").tag(IssueDue.today)
							Text("Tomorrow").tag(IssueDue.tomorrow)
							Text("Overdue").tag(IssueDue.overdue)
							Text("Week").tag(IssueDue.week)
							Text("Month").tag(IssueDue.month)
							Text("Next month and previous two weeks").tag(IssueDue.nextMonthAndPreviousTwoWeeks)
						}
						
						Picker("Scope", selection: $scope) {
							Text("All").tag(IssueScope.all)
							Text("Created by me").tag(IssueScope.createdByMe)
							Text("Assigned to me").tag(IssueScope.assignedToMe)
						}
					}
					
					Section {
						Picker("Type", selection: $type) {
							Text("All").tag(IssueType.all)
							Label("Issue", systemImage: "smallcircle.circle").tag(IssueType.issue)
							Label("Incident", systemImage: "exclamationmark.circle").tag(IssueType.incident)
							Label("Test case", systemImage: "testtube.2").tag(IssueType.testCase)
						}
						
						Toggle("Confidential", isOn: $confidential)
					}
					
					AsyncButton("Apply") {
						issues = nil
						issues = await getIssues()
						loadFailed = (issues == nil)
						showFilter = false
					}
				}
			}.navigationTitle("Issues")
	}
	
	private func getIssues() async -> [Issue]? {
		var filter = ["with_labels_details": "true"]
		
		// Search
		let _search: String = search.trim()
		if (_search != "") {
			filter["search"] = _search
		}
		
		// Filters
		if (state != .all) {
			filter[IssueState.NAME.rawValue] = state.rawValue
		}
		
		filter[ProjectSort.NAME.rawValue] = sort.rawValue
		filter[IssueOrder.NAME.rawValue] = orderBy.rawValue
		
		if (type != .all) {
			filter[IssueType.NAME.rawValue] = type.rawValue
		}
		
		if (confidential) {
			filter["confidential"] = "true"
		}
		
		if (dueDate != .all) {
			filter[IssueDue.NAME.rawValue] = dueDate.rawValue
		}
		
		filter[IssueScope.NAME.rawValue] = scope.rawValue
		
		var endpoint = "issues"
		if (id != 0) {
			endpoint = "projects/\(id)/issues"
		}
		if (groupId != 0) {
			endpoint = "groups/\(groupId)/issues"
		}
		
		if (milestone != nil) {
			filter["milestone"] = milestone
		}
		
		return await API.get(type: [Issue].self, endpoint: endpoint, query: filter)
	}
}

struct IssuesLoader_Previews: PreviewProvider {
	static var previews: some View {
		IssuesLoader(id: 0)
	}
}
