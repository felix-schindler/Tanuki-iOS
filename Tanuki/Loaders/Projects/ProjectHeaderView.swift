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

struct ProjectHeaderView: View {
	private let project: ProjectQuery.Data.Project

	init(_ project: ProjectQuery.Data.Project) {
		self.project = project
	}

	var body: some View {
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

			if let description = project.description {
				Markdown(description.emojized())
					.markdownTheme(.gitLab)
			}

			HStack {
				if project.topics != nil
					&& project.topics!.count > 0
				{
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
					Spacer()
				}

				if let createdAt = project.createdAt {
					Spacer()
					Text(
						Date.fromToString(
							createdAt,
							dateStyle: .short)
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
						}
					}

					Button(
						String(project.starCount),
						systemImage: "star"
					) {
					}

					if let projectUrl = URL(
						string:
							"\(project.webUrl ?? "")/-/forks/new")
					{
						Link(destination: projectUrl) {
							Label(
								String(project.forksCount),
								systemImage: "tuningfork")
						}
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
					ForEach(project.languages!, id: \.self) {
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
					range: project.languages!.map {
						Color(hex: $0.color) ?? .accentColor
					}
				)
				.frame(height: 30)
			}
		}
	}
}
