//
//  IssueFilter.swift
//  GitLab
//
//  Created by Felix Schindler on 19.03.23.
//

import Foundation

enum IssueState: String {
	case NAME = "state"
	case opened = "opened",
			 closed = "closed",
			 all
}

enum IssueSort: String {
	case NAME = "sort"
	case asc = "asc",
			 desc = "desc"
}

enum IssueOrder: String {
	case NAME = "order_by"
	case createdAt = "created_at",
			 dueDate = "due_date",
			 labelPriority = "label_priority",
			 milestoneDue = "milestone_due",
			 popularity = "popularity",
			 priority = "priority",
			 relativePosition = "relative_position",
			 title = "title",
			 updatedAt = "updated_at",
			 weight = "weight"
}

enum IssueType: String {
	case NAME = "issue_type"
	case issue = "issue",
			 incident = "incident",
			 testCase = "test_case",
			 all
}

enum IssueConfidential: String {
	case NAME = "confidential"
	case confidential = "true",
			 _public = "false",
			 all
}

enum IssueDue: String {
	case NAME = "due_date"
	case noDueDate = "0",
			 any = "any",
			 today = "today",
			 tomorrow = "tomorrow",
			 overdue = "overdue",
			 week = "week",
			 month = "month",
			 nextMonthAndPreviousTwoWeeks = "next_month_and_previous_two_weeks",
			 all
}

enum IssueScope: String {
	case NAME = "scope"
	case createdByMe = "created_by_me",
			 assignedToMe = "assigned_to_me",
			 all = "all"
}
