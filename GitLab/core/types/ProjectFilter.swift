//
//  ProjectFilter.swift
//  GitLab
//
//  Created by Felix Schindler on 20.03.23.
//

import Foundation

enum ProjectOrder: String {
	case NAME = "order_by"
	case id = "id",
			 name = "name",
			 path = "path",
			 createdAt = "created_at",
			 updatedAt = "updated_at",
			 lastActivityAt = "last_activity_at",
			 similarity = "similarity"
}

enum ProjectSort: String {
	case NAME = "sort"
	case asc = "asc",
			 desc = "desc"
}

enum ProjectVisibility: String {
	case NAME = "visibility"
	case `public` = "public",
			 `internal` = "internal",
			 `private` = "private",
			 all
}
