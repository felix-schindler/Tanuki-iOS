//
//  ProjectHeaderView.swift
//  Tanuki
//
//  Created by Felix Schindler on 10.09.25.
//

import Charts
import GitLabAPI
import MarkdownUI
import SwiftUI

struct ToggleStar: Codable {
	let starCount: Int
}

struct ProjectHeaderView: View {
	private let project: ProjectQuery.Data.Project

	@State
	private var starCount: Int

	init(_ project: ProjectQuery.Data.Project) {
		self.project = project
		self.starCount = project.starCount
	}

	private func star(_ fullPath: String) async {
		do {
			let toggle = try await API.req(
				type: ToggleStar.self, method: .post, endpoint: "\(fullPath)/toggle_star.json", useBase: false)
			self.starCount = toggle.starCount
			Notify.status(.success, "Toggled star")
		} catch let error {
			Notify.status(.error, "Failed to toggle star", error.localizedDescription, systemImage: "star")
		}
	}

	public var body: some View {
		VStack(alignment: .leading) {
			HStack {
				if let avatarUrl = URL.fromAvatar(project.avatarUrl) {
					AvatarImage(avatarUrl, size: .medium)
				}
				Spacer()
				Text(project.name)
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
								ForEach(project.topics!, id: \.self) { topic in
									PillView(topic)
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
						if namespace.id.contains("UserNamespace") {
							NavigationLink(
								destination: UserLoader(username: namespace.fullPath),
								label: {
									Label(
										namespace.name,
										systemImage: "person"
									)
								}
							)
							.tint(.accentColor)
							.buttonStyle(.borderedProminent)
						} else if namespace.id.contains("Group") {
							NavigationLink(
								destination: GroupLoader(fullPath: namespace.fullPath),
								label: {
									Label(
										namespace.name,
										systemImage: "scale.3d"
									)
								}
							)
							.tint(.accentColor)
							.buttonStyle(.borderedProminent)
						} else {
							PillView(namespace.name)
						}
					}

					if let fullPath = project.namespace?.fullPath {
						AsyncButton(
							String(project.starCount),
							systemImage: "star"
						) {
							await star(fullPath)
						}
						.tint(.accentColor)
						.buttonStyle(.bordered)
					} else {
						PillView(
							String(project.starCount),
							icon: "star"
						)
					}

					if project.userPermissions.forkProject,
						let projectUrl = URL(string: "\(project.webUrl ?? "")/-/forks/new")
					{
						Link(destination: projectUrl) {
							Label(String(project.forksCount), systemImage: "tuningfork")
						}
						.tint(.accentColor)
						.buttonStyle(.bordered)
					} else {
						PillView(
							String(project.forksCount),
							icon: "tuningfork"
						)
					}
				}
				.tint(.primary)
				.buttonStyle(.bordered)
				.controlSize(.small)
			}

			if #available(iOS 16.0, *),
				let languages = project.languages,
				languages.isNotEmpty
			{
				Chart {
					ForEach(languages, id: \.self) {
						language in
						BarMark(
							x: .value(
								"Percent", language.share ?? 1)
						).foregroundStyle(
							by: .value("Language", language.name)
						)
					}
				}
				.chartXAxis(.hidden)
				.chartForegroundStyleScale(
					range: languages.map {
						Color(hex: $0.color) ?? .accentColor
					}
				)
				.frame(height: 30)
			}
		}
	}
}
