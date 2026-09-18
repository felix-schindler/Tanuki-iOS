#!/usr/bin/env swift
//
//  gen-symbolsets.swift
//  Tanuki
//
//  Generates the Android symbol assets for SF Symbols that SkipUI cannot map.
//
//  SkipUI resolves `Image(systemName:)` on Android in three steps (see
//  skip-ui/Sources/SkipUI/SkipUI/Components/Image.swift, `RenderSystem`):
//
//    1. a `<systemName>.symbolset` asset in the app module's asset catalog,
//    2. a built-in table of ~65 SF Symbols mapped to Compose Material icons,
//    3. `Icons.Default.Warning` plus an "Unable to find system image" log line.
//
//  This script writes step 1 for every symbol the app uses that step 2 does not
//  cover, so iOS keeps Apple's SF Symbol while Android renders an equivalent
//  glyph. It also rewrites the four icons loaded by name
//  (`Image("git-mr.symbols", bundle: .module)`) as 16x16 imagesets: the
//  hand-made symbolsets they replaced put their paths on a ~110 unit canvas,
//  which SkipUI turns into a ~110 dp intrinsic size.
//
//  Artwork
//    - Material Symbols, Apache License 2.0 (`material-symbols-LICENSE.txt`)
//    - GitLab SVG icons, MIT (`gitlab-svgs-LICENSE.txt`)
//
//  Do not use exports from Apple's SF Symbols app: that licence covers Apple
//  platforms only.
//
//  Usage
//    swift scripts/gen-symbolsets.swift            # write missing assets
//    swift scripts/gen-symbolsets.swift --verify   # only check the sources
//

import Foundation

// MARK: - Configuration

let repoRoot = URL(fileURLWithPath: #filePath)
	.deletingLastPathComponent()
	.deletingLastPathComponent()
	.standardizedFileURL
let catalog = repoRoot.appendingPathComponent("tanuki-app/Sources/Tanuki/Resources/Module.xcassets")

let materialSymbolsBase = "https://raw.githubusercontent.com/marella/material-symbols/main/svg/400/outlined"
let gitlabSVGsBase = "https://gitlab.com/gitlab-org/gitlab-services/design.gitlab.com/-/raw/main/packages/gitlab-svgs/sprite_icons"

/// SF Symbol name -> Material Symbols slug (outlined, weight 400).
/// Chosen for shape first, meaning second, mirroring skiptools/skip-ui#525.
let symbolMapping: [String: String] = [
	"1.circle.fill": "looks_one",
	"2.circle.fill": "looks_two",
	"3.circle.fill": "looks_3",
	"4.circle.fill": "looks_4",
	"5.circle.fill": "looks_5",
	"alarm": "alarm",
	"app.gift.fill": "redeem-fill",
	"arrow.2.circlepath": "sync",
	"arrow.2.circlepath.circle": "sync",
	"arrow.right": "arrow_forward",
	"arrow.right.page.on.clipboard": "content_paste_go",
	"arrow.right.square": "exit_to_app",
	"arrow.triangle.pull": "merge",
	"arrow.triangle.swap": "swap_horiz",
	"arrow.up": "arrow_upward",
	"arrowshape.turn.up.forward": "forward",
	"briefcase": "work",
	"calendar.badge.checkmark": "event_available",
	"checkmark.seal": "verified",
	"checkmark.square": "check_box",
	"checkmark.square.fill": "check_box-fill",
	"chevron.left.forwardslash.chevron.right": "code",
	"chevron.right.circle": "chevron_right",
	"circle.and.line.horizontal": "commit",
	"circlebadge.2": "bubble_chart",
	"clock": "schedule",
	"clock.arrow.circlepath": "history",
	"diamond": "diamond",
	"doc.on.doc": "content_copy",
	"doc.text": "description",
	"doc.zipper": "folder_zip",
	"document": "draft",
	"dot.square": "fiber_manual_record",
	"ellipsis.bubble": "sms",
	"exclamationmark.bubble": "feedback",
	"figure.and.child.holdinghands": "family_restroom",
	"figure.child": "child_care",
	"flag": "flag",
	"folder": "folder",
	"gear": "settings",
	"gear.circle": "settings",
	"globe": "public",
	"hand.raised": "front_hand",
	"hand.thumbsdown": "thumb_down",
	"hourglass": "hourglass_empty",
	"hourglass.circle": "hourglass_empty",
	"internaldrive": "storage",
	"key": "key",
	"line.3.horizontal.decrease": "filter_list",
	"link": "link",
	"link.badge.plus": "add_link",
	"lock.circle": "lock",
	"mappin.and.ellipse": "location_on",
	"minus.circle": "do_not_disturb_on",
	"minus.circle.fill": "do_not_disturb_on-fill",
	"minus.square": "indeterminate_check_box",
	"note.text": "comment",
	"number": "numbers",
	"pause.circle": "pause_circle",
	"pencil.and.scribble": "edit_note",
	"person.2": "group",
	"person.badge.plus": "person_add",
	"person.fill.checkmark": "how_to_reg",
	"person.fill.xmark": "person_remove",
	"person.line.dotted.person.fill": "connect_without_contact",
	"photo": "image",
	"plus.circle": "add_circle",
	"plus.square": "add_box",
	"plusminus": "exposure",
	"questionmark": "question_mark",
	"scale.3d": "view_in_ar",
	"scalemass": "scale",
	"scissors": "content_cut",
	"server.rack": "dns",
	"shield.lefthalf.filled": "security",
	"slash.circle": "block",
	"smallcircle.circle": "adjust",
	"sparkles": "stars",
	"square": "check_box_outline_blank",
	"star": "star",
	"star.square.on.square.fill": "star-fill",
	"tag": "sell",
	"testtube.2": "science",
	"text.line.first.and.arrowtriangle.forward": "format_indent_increase",
	"tuningfork": "fork_right",
	"waveform.path.ecg": "monitor_heart",
]

/// Icons loaded by name. GitLab's own state mapping is open/close/merge
/// (see GitLab's `status_badge` component); Material has no cookie.
let namedIcons: [(name: String, url: String)] = [
	("git-mr.symbols", "\(gitlabSVGsBase)/merge-request-open.svg"),
	("git-mr-closed.symbols", "\(gitlabSVGsBase)/merge-request-close.svg"),
	("git-mr-merged.symbols", "\(gitlabSVGsBase)/merge.svg"),
	("cookie.symbols", "\(materialSymbolsBase)/cookie.svg"),
]

// MARK: - Templates

/// The asset-catalog templates live as real files so this script stays readable
/// (and free of the indentation churn swift-format applies to multi-line string
/// literals).
let templatesDirectory = repoRoot.appendingPathComponent("scripts/templates")

func template(_ name: String) throws -> String {
	try String(contentsOf: templatesDirectory.appendingPathComponent(name), encoding: .utf8)
}

// MARK: - Helpers

enum ScriptError: Error, CustomStringConvertible {
	case badURL(String)
	case noSinglePath(String, Int)
	case notUTF8(String)

	var description: String {
		switch self {
		case .badURL(let url): return "invalid URL: \(url)"
		case .noSinglePath(let url, let count): return "\(url): expected exactly one <path>, found \(count)"
		case .notUTF8(let url): return "\(url): not valid UTF-8"
		}
	}
}

func download(_ urlString: String) throws -> String {
	guard let url = URL(string: urlString) else { throw ScriptError.badURL(urlString) }
	let data = try Data(contentsOf: url)
	guard let svg = String(data: data, encoding: .utf8) else { throw ScriptError.notUTF8(urlString) }
	return svg
}

/// The single `<path d="…">` of a Material Symbols SVG.
func materialPath(forSlug slug: String) throws -> String {
	let url = "\(materialSymbolsBase)/\(slug).svg"
	let svg = try download(url)
	let pattern = #"<path[^>]*\sd="([^"]+)""#
	let regex = try NSRegularExpression(pattern: pattern)
	let matches = regex.matches(in: svg, range: NSRange(svg.startIndex..., in: svg))
	guard matches.count == 1, let range = Range(matches[0].range(at: 1), in: svg) else {
		throw ScriptError.noSinglePath(url, matches.count)
	}
	return String(svg[range])
}

/// Rewrite an icon SVG to a 16x16 intrinsic size, which is what both ImageIO
/// (iOS) and Coil (Android) use when the image is not explicitly framed.
func normalizedTo16(_ svg: String) -> String {
	var result = svg
	for attribute in ["width", "height"] {
		result = result.replacingOccurrences(
			of: #"\#(attribute)="[^"]*""#, with: #"\#(attribute)="16""#, options: .regularExpression)
	}
	return result
}

func write(_ contents: String, to url: URL) throws {
	try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
	try contents.write(to: url, atomically: true, encoding: .utf8)
}

func removeIfPresent(_ url: URL) {
	if FileManager.default.fileExists(atPath: url.path) {
		try? FileManager.default.removeItem(at: url)
	}
}

// MARK: - Generation

let verifyOnly = CommandLine.arguments.contains("--verify")
var failures: [String] = []

// 1. `<systemName>.symbolset` for every unmapped SF Symbol.
for (index, entry) in symbolMapping.sorted(by: { $0.key < $1.key }).enumerated() {
	let (systemName, slug) = entry
	let position = "[\(index + 1)/\(symbolMapping.count)]"
	do {
		let path = try materialPath(forSlug: slug)
		guard !verifyOnly else {
			print("\(position) ok   \(systemName) -> \(slug)")
			continue
		}
		let filename = "\(systemName).svg"
		let directory = catalog.appendingPathComponent("\(systemName).symbolset")
		try write(template("symbolset-Contents.json").replacingOccurrences(of: "__FILENAME__", with: filename), to: directory.appendingPathComponent("Contents.json"))
		try write(template("symbolset.svg").replacingOccurrences(of: "__PATH__", with: path), to: directory.appendingPathComponent(filename))
		print("\(position) wrote \(systemName) <- \(slug)")
	} catch {
		failures.append("\(systemName) -> \(slug): \(error)")
		print("\(position) FAIL \(systemName) -> \(slug)")
	}
}

// 2. 16x16 imagesets for the icons loaded by name.
for (index, icon) in namedIcons.enumerated() {
	let position = "[icon \(index + 1)/\(namedIcons.count)]"
	do {
		let svg = try download(icon.url)
		guard !verifyOnly else {
			print("\(position) ok   \(icon.name)")
			continue
		}
		let filename = "\(icon.name).svg"
		let directory = catalog.appendingPathComponent("\(icon.name).imageset")
		// Replace the old symbolset form so name lookups are unambiguous.
		removeIfPresent(catalog.appendingPathComponent("\(icon.name).symbolset"))
		removeIfPresent(directory)
		try write(template("imageset-Contents.json").replacingOccurrences(of: "__FILENAME__", with: filename), to: directory.appendingPathComponent("Contents.json"))
		try write(normalizedTo16(svg), to: directory.appendingPathComponent(filename))
		print("\(position) wrote \(icon.name)")
	} catch {
		failures.append("\(icon.name): \(error)")
		print("\(position) FAIL \(icon.name)")
	}
}

if failures.isEmpty {
	print(verifyOnly ? "\nall sources reachable" : "\n\(symbolMapping.count) symbolsets + \(namedIcons.count) imagesets up to date")
	exit(0)
}

func warn(_ message: String) {
	FileHandle.standardError.write(Data((message + "\n").utf8))
}
warn("\n\(failures.count) failure(s):")
for failure in failures {
	warn("  \(failure)")
}
exit(1)
