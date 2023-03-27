//
//  MergeFilter.swift
//  GitLab
//
//  Created by Felix Schindler on 20.03.23.
//

import Foundation

enum MergeOrder: String {
	case NAME  = "order_by"
	case createdAt = "created_at",
			 title = "title",
			 updatedAt = "updated_at"
}

enum MergeState: String {
	case NAME  = "state"
	case opened = "opened",
			 closed = "closed",
			 locked = "locked",
			 merged = "merged",
			 all
}
