//
//  SingleProjectIssuesView.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import SwiftUI

struct IssuesLoader: View {
	@State var id: Int? = nil
	@State var showNewIssue: Bool = false
	@State var showFilter: Bool = false
	
	@State var issues: [Issue]? = nil
	@State var loadFailed: Bool = false
	
	// Search
	@State var search: String = ""
	
	// Filters
	@State var state: IssueState = .opened
	@State var sort: IssueSort = .desc
	@State var orderBy: IssueOrder = .createdAt
	@State var type: IssueType = .all
	@State var confidential: IssueConfidential = .all
	@State var dueDate: IssueDue = .all
	@State var scope: IssueScope = .createdByMe
	
	// @State var assignees
	// @State var author
	// @State var createdAfter
	// @State var createdBefore
	// @State var iids
	// @State var labels
	// @State var milestone
	// @State var not
	// @State var updatedAfter
	// @State var updatedBefore
	
	var body: some View {
		VStack {
			if (issues != nil) {
				IssueListView(issues: issues!, updateFunction: getIssues, showRef: (id == nil))
					.searchable(text: $search)
					.onSubmit(of: .search) {
						Task.init {
							issues = nil
							issues = await getIssues()
							loadFailed = (issues == nil)
						}
					}
					.toolbar {
						ToolbarItemGroup(placement: .navigationBarTrailing) {
							Button(action: {showFilter = true}) {
								Image(systemName: "line.3.horizontal.decrease.circle")
							}
							if (id != nil) {
								Button(action: {showNewIssue = true}) {
									Image(systemName: "plus.circle")
								}
							}
						}
					}.sheet(isPresented: $showNewIssue) {
						NewIssueView(id: id!)
					}.sheet(isPresented: $showFilter) {
						List {
							Section {
								Picker("State", selection: $state) {
									Text("Open").tag(IssueState.opened)
									Text("Closed").tag(IssueState.closed)
									Text("All").tag(IssueState.all)
								}
								
								Picker("Sort", selection: $sort) {
									Text("Ascending").tag(IssueSort.asc)
									Text("Descending").tag(IssueSort.desc)
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
									Text("Issue").tag(IssueType.issue)
									Text("Incident").tag(IssueType.incident)
									Text("Test case").tag(IssueType.testCase)
								}
								
								Picker("Confidential", selection: $confidential) {
									Text("All").tag(IssueConfidential.all)
									Text("Confidential").tag(IssueConfidential.confidential)
									Text("Public").tag(IssueConfidential._public)
								}
							}
							
							AsyncButton(action: {
								issues = nil
								issues = await getIssues()
								loadFailed = (issues == nil)
								showFilter = false
							}, label: {
								Text("Apply")
							})
						}
					}
			} else {
				if (loadFailed) {
					Text("Failed to load, please check your internet connection and your token")
				} else {
					Spacer()
					ProgressView("Loading")
					Spacer()
				}
			}
		}.onAppear {
			Task.init {
				issues = await getIssues()
				loadFailed = (issues == nil)
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
		
		filter[IssueSort.NAME.rawValue] = sort.rawValue
		filter[IssueOrder.NAME.rawValue] = orderBy.rawValue
		
		if (type != .all) {
			filter[IssueType.NAME.rawValue] = type.rawValue
		}
		
		if (confidential != .all) {
			filter[IssueConfidential.NAME.rawValue] = confidential.rawValue
		}
		
		if (dueDate != .all) {
			filter[IssueDue.NAME.rawValue] = dueDate.rawValue
		}
		
		filter[IssueScope.NAME.rawValue] = scope.rawValue
		
		var endpoint = "issues"
		if (id != nil) {
			endpoint = "projects/\(id!)/issues"
		}
		
		return await API.get(type: [Issue].self, endpoint: endpoint, query: filter)
	}
}

struct IssuesLoader_Previews: PreviewProvider {
	static var previews: some View {
		IssuesLoader(id: nil)
	}
}
