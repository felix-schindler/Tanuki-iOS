//
//  JumpURL.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.09.26.
//

import Foundation

enum JumpTarget: Hashable {
	case project(fullPath: String)
	case group(fullPath: String)
	case projectRoute(fullPath: String, route: ProjectRoute)
}

enum ProjectRoute: Hashable {
	case issues(iid: String)
	case mergeRequests(iid: String)
	case tree(ref: String)
	case releases(tag: String)
}

enum ResolvedProjectRoute: Hashable {
	case issues(fullPath: String)
	case mergeRequests(fullPath: String)
	case tree(projectId: Int, fullPath: String, ref: String)
	case releases(fullPath: String, projectId: Int)
}

enum JumpURLError: LocalizedError, Equatable {
	case notAURL
	case wrongHost(String)
	case nothingToOpen

	var errorDescription: String? {
		switch self {
		case .notAURL:
			return "The clipboard doesn't contain a link."
		case .wrongHost(let host):
			return "That link is for \(host), which isn't the instance you're signed in to."
		case .nothingToOpen:
			return "That link doesn't point at anything in this app."
		}
	}
}

enum JumpURL {
	private static let separator = "-"

	static func parse(_ raw: String, host: String) throws -> JumpTarget {
		let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
		guard let url = URL(string: trimmed), let scheme = url.scheme,
			scheme == "http" || scheme == "https",
			let urlHost = url.host()
		else {
			throw JumpURLError.notAURL
		}

		guard urlHost.caseInsensitiveCompare(host) == .orderedSame else {
			throw JumpURLError.wrongHost(urlHost)
		}

		let segments = url.pathComponents.filter { $0 != "/" && !$0.isEmpty }
		guard !segments.isEmpty else { throw JumpURLError.nothingToOpen }

		guard let separatorIndex = segments.firstIndex(of: separator) else {
			return .project(fullPath: segments.joined(separator: "/"))
		}

		let fullPath = segments[..<separatorIndex].joined(separator: "/")
		guard fullPath.isNotEmpty else { throw JumpURLError.nothingToOpen }

		let rest = Array(segments[segments.index(after: separatorIndex)...])
		guard let kind = rest.first, rest.count >= 2 else {
			return .project(fullPath: fullPath)
		}
		let value = rest[1]

		switch kind {
		case "issues":
			return .projectRoute(fullPath: fullPath, route: .issues(iid: value))
		case "merge_requests":
			return .projectRoute(fullPath: fullPath, route: .mergeRequests(iid: value))
		case "releases":
			return .projectRoute(fullPath: fullPath, route: .releases(tag: value))
		case "tree":
			return .projectRoute(fullPath: fullPath, route: .tree(ref: value))
		case "blob", "commits", "commit", "pipelines", "jobs", "labels", "milestones", "members",
			"settings", "snippets", "wikis", "activity", "graphs", "forks":
			return .project(fullPath: fullPath)
		default:
			return .project(fullPath: fullPath)
		}
	}
}
