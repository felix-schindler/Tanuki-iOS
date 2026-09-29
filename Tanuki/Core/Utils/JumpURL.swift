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

#if DEBUG
	enum JumpURLSelfCheck {
		static func run() {
			let host = "gitlab.com"
			func target(_ url: String) -> JumpTarget? {
				try? JumpURL.parse(url, host: host)
			}

			assert(
				target("https://gitlab.com/a/b") == .project(fullPath: "a/b"),
				"plain project path")
			assert(
				target("https://gitlab.com/a/b/c/d") == .project(fullPath: "a/b/c/d"),
				"nested group project path keeps all segments")
			assert(
				target("https://gitlab.com/a/b/-/issues/12")
					== .projectRoute(fullPath: "a/b", route: .issues(iid: "12")),
				"issue link")
			assert(
				target("https://gitlab.com/a/b/-/merge_requests/7")
					== .projectRoute(fullPath: "a/b", route: .mergeRequests(iid: "7")),
				"merge request link")
			assert(
				target("https://gitlab.com/a/b/-/releases/v1.2.3")
					== .projectRoute(fullPath: "a/b", route: .releases(tag: "v1.2.3")),
				"release link")
			assert(
				target("https://gitlab.com/a/b/-/tree/main")
					== .projectRoute(fullPath: "a/b", route: .tree(ref: "main")),
				"tree link")
			assert(
				target("https://gitlab.com/a/b/-/blob/main/README.md")
					== .project(fullPath: "a/b"),
				"unsupported sub-page falls back to the project")
			assert(
				target("https://gitlab.com/a/b/-/issues/12#note_99")
					== .projectRoute(fullPath: "a/b", route: .issues(iid: "12")),
				"fragment is ignored")
			assert(
				target("https://gitlab.com/a/b/-/issues/12?foo=bar")
					== .projectRoute(fullPath: "a/b", route: .issues(iid: "12")),
				"query is ignored")
			assert(
				target("https://gitlab.com/a/b/") == .project(fullPath: "a/b"),
				"trailing slash")
			assert(
				target("  https://gitlab.com/a/b  ") == .project(fullPath: "a/b"),
				"surrounding whitespace")
			assert(
				target("https://gitlab.com/a/b/-/") == .project(fullPath: "a/b"),
				"bare separator")
			assert(target("tanuki://oauth/callback") == nil, "non-http scheme rejected")
			assert(target("hello world") == nil, "garbage rejected")
			do {
				_ = try JumpURL.parse("https://evil.example/a/b", host: host)
				assertionFailure("foreign host was accepted")
			} catch let error as JumpURLError {
				assert(error == .wrongHost("evil.example"), "foreign host rejected, got \(error)")
			} catch {
				assertionFailure("unexpected error for foreign host: \(error)")
			}
			assert(target("https://gitlab.com") == nil, "bare host rejected")
		}
	}
#endif
