//
//  ProjectHeaderView.swift
//  Tanuki
//
//  Created by Felix Schindler on 10.09.25.
//

import GitLabAPI
//import MarkdownUI
import SwiftUI

#if canImport(Charts)
	import Charts
#endif

struct ToggleStar: Codable {
	let starCount: Int
}

struct ProjectHeaderView: View {
	private let project: Project_Project

	@State var starCount: String

	init(_ project: Project_Project) {
		self.project = project
		self.starCount = project.starCount ?? "0"
	}

	private func star() async {
		do {
			_ = try await Network.shared.service.fetchStarProject(projectId: project.id ?? "", starred: true)
			Notify.status(.success, "Project starred", systemImage: "star")
		} catch let error {
			Notify.status(.error, "Starring project failed", error.localizedDescription, systemImage: "xmark")
		}
	}

	public var body: some View {
		VStack(alignment: .leading) {
			HStack {
				if let avatarUrl = URL.fromAvatar(project.avatarUrl) {
					AvatarImage(avatarUrl, size: .medium)
				}
				Spacer()
				Text(project.name ?? "")
					.font(.title)
					.fontWeight(.bold)
				Spacer()
				if let visibility = project.visibility {
					VisibilityIcon(visibility)
				}
			}

			if let description = project.description?.emojized() {
				Markdown(description)
					.markdownTheme(.gitLab)
			}

			HStack {
				if let topics = project.topics, topics.isNotEmpty {
					HStack(spacing: 5) {
						Label("Tags", systemImage: "tag")
							.labelStyle(.iconOnly)
						ScrollView(.horizontal) {
							HStack {
								let topicList = topics.components(separatedBy: ",")
								ForEach(topicList, id: \.self) { topic in
									PillView(topic.trimmingCharacters(in: .whitespaces))
								}
							}
						}
					}
				}

				if let createdAt = project.createdAt {
					Spacer()
					Text(
						Date.fromToString(
							createdAt,
							dateStyle: .short
						)
					)
				}
			}.font(.footnote)

			ScrollView(.horizontal) {
				HStack {
					if let namespace = project.namespace {
						if let namespaceId = namespace.id, namespaceId.contains("User") {
							NavigationLink(
								destination: UserLoader(username: namespace.fullPath ?? ""),
								label: {
									Label(
										namespace.name ?? "",
										systemImage: "person"
									)
								}
							)
							.tint(.accentColor)
							.buttonStyle(.borderedProminent)
						} else {
							NavigationLink(
								destination: GroupLoader(fullPath: namespace.fullPath ?? ""),
								label: {
									Label(
										namespace.name ?? "",
										systemImage: "scale.3d"
									)
								}
							)
							.tint(.accentColor)
							.buttonStyle(.borderedProminent)
						}
					}

					AsyncButton(
						starCount,
						systemImage: "star"
					) {
						await star()
					}
					.tint(.accentColor)
					.buttonStyle(.bordered)

					if project.userPermissions?.forkProject == "true",
						let webUrl = project.webUrl,
						let projectUrl = URL(string: "\(webUrl)/-/forks/new")
					{
						Link(destination: projectUrl) {
							Label(project.forksCount ?? "0", systemImage: "tuningfork")
						}
						.tint(.accentColor)
						.buttonStyle(.bordered)
					} else {
						PillView(
							project.forksCount ?? "0",
							icon: "tuningfork"
						)
					}
				}
				.tint(.primary)
				.buttonStyle(.bordered)
				.controlSize(.small)
			}

			#if canImport(Charts)
				if #available(iOS 16.0, *),
					let language = project.languages
				{
					Chart {
						BarMark(
							x: .value(
								"Percent", Double(language.share ?? "1") ?? 1)
						).foregroundStyle(
							by: .value("Language", language.name ?? "")
						)
					}
					.chartXAxis(.hidden)
					.chartForegroundStyleScale(
						range: [Color(hex: language.color ?? Color.accentColor.hex)]
					)
					.frame(height: 30)
				}
			#endif
		}
	}
}
