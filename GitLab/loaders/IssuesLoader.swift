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
	
	@State var showNewIssue = false
	@State var showFilter = false
	
	@State var issues: [Issue]? = nil
	@State var loadFailed = false
	
	// Search
	@State var search = ""
	
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
				RoundIconButton("Filters", icon: "line.3.horizontal.decrease") {
					showFilter = true
				}
				if (id != 0) {
					RoundIconButton("New Issue", icon: "plus") {
						showNewIssue = true
					}
				}
			}.sheet(isPresented: $showNewIssue) {
				NewIssueView(id: id)
			}.sheet(isPresented: $showFilter) {
				VStack {
					Form {
						Section {
							Picker("State", selection: $state) {
								Label("Open", systemImage: "smallcircle.circle")
									.tag(IssueState.opened)
								Label("Closed", systemImage: "minus.circle")
									.tag(IssueState.closed)
								Text("All").tag(IssueState.all)
							}
							
							Picker("Sort", selection: $sort) {
								Label("Ascending", systemImage: "increase.indent")
									.tag(ProjectSort.asc)
								Label("Descending", systemImage: "decrease.indent")
									.tag(ProjectSort.desc)
							}
							
							Picker("Order by", selection: $orderBy) {
								Label("Created at", systemImage: "doc.badge.plus")
									.tag(IssueOrder.createdAt)
								Label("Due date", systemImage: "calendar")
									.tag(IssueOrder.dueDate)
								Label("Label priority", systemImage: "tag")
									.tag(IssueOrder.labelPriority)
								Label("Milestone due", systemImage: "calendar.badge.clock")
									.tag(IssueOrder.milestoneDue)
								Label("Popularity", systemImage: "hand.thumbsup")
									.tag(IssueOrder.popularity)
								Label("Priority", systemImage: "exclamationmark")
									.tag(IssueOrder.priority)
								Label("Relative position", systemImage: "list.number")
									.tag(IssueOrder.relativePosition)
								Label("Title", systemImage: "number")
									.tag(IssueOrder.title)
								Label("Updated at", systemImage: "doc.badge.clock")
									.tag(IssueOrder.updatedAt)
								Label("Weight", systemImage: "lineweight")
									.tag(IssueOrder.weight)
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
								Label("Created by me", systemImage: "person.badge.plus")
									.tag(IssueScope.createdByMe)
								Label("Assigned to me", systemImage: "person")
									.tag(IssueScope.assignedToMe)
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
					}
					
					VStack {
						AsyncButton(action: {
							issues = nil
							issues = await getIssues()
							loadFailed = (issues == nil)
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
		NavigationStack {
			IssuesLoader(id: 33025310)
		}
	}
}
