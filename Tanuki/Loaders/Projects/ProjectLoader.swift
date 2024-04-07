//
//  Project.swift
//  Tanuki
//
//  Created by Felix Schindler on 31.10.21.
//  Rewritten by Felix Schindler on 14.03.23 and 26.02.24.
//

import Charts
import GitLabAPI
import MarkdownUI
import NVMColor
import SwiftUI

struct ProjectLoader: View {
	private let fullPath: String

	@State
	private var project: ProjectQuery.Data.Project? = nil

	@State
	private var loadFailed = false

	@State
	private var showNewIssue = false

	/// Selected special file (README, LICENSE, ...)
	@State
	private var selectedFile = 0

	init(fullPath: String) {
		self.fullPath = fullPath
	}

	private func loadProject() {
		Network.shared.apollo.fetch(query: ProjectQuery(fullPath: fullPath)) {
			result in
			switch result {
			case .success(let graphQLResult):
				print("Success! Setting project...")
				self.project = graphQLResult.data?.project
			case .failure(let error):
				print("Failure! Error: \(error)")
				self.loadFailed = true
			}
		}
	}

	public var body: some View {
		List {
			Section {
				if let project = self.project {
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

						if project.languages != nil
							&& !project.languages!.isEmpty
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
				} else {
					VStack {
						if loadFailed {
							Text(failedToLoad)
						} else {
							ProgressView("Loading project")
						}
					}.frame(maxWidth: .infinity, minHeight: 250)
				}
			}

			if let lastCommit = project?.repository?.tree?.lastCommit {
				Section("Last commit") {
					SmallCommitView(lastCommit)
				}
			}

			Section("Actions") {
				if project == nil || (project!.issuesEnabled ?? false) {
					NavigationLink(
						destination: ProjectIssuesLoader(
							fullPath: self.fullPath),
						label: {
							Label(
								title: {
									Text("Issues")
									Spacer()
									if project != nil {
										Text(
											String(
												project!.openIssuesCount ?? 0))
									}
								},
								icon: {
									Image(systemName: "smallcircle.circle")
										.foregroundStyle(.green)
								})
						}
					)
				}

				if project == nil || (project!.mergeRequestsEnabled ?? false) {
					NavigationLink(
						destination: ProjectMergeLoader(
							fullPath: self.fullPath),
						label: {
							Label(
								title: {
									Text("Merge Requests")
									Spacer()
									if project != nil {
										Text(
											String(
												project!.openMergeRequestsCount
													?? 0))
									}
								},
								icon: {
									Image(systemName: "arrow.triangle.pull")
										.foregroundStyle(.blue)
								})
						}
					)
				}

				DisclosureGroup(
					content: {
						if let id = project?.id.toIntId() {
							NavigationLink(
								destination: EventsLoader(projectId: id),
								label: {
									Text("Activity")
								})
						}
						NavigationLink(
							"Members",
							destination: MembersLoader(fullPath: self.fullPath, type: .project)
						)
						NavigationLink(
							"Labels",
							destination: LabelsLoader(fullPath: self.fullPath, queryType: .project)
						)
						NavigationLink(
							"Milestones",
							destination: MilestonesLoader(
								fullPath: self.fullPath,
								queryType: .project
							)
						)
					},
					label: {
						Label("Manage", systemImage: "person.2")
					})

				DisclosureGroup(
					content: {
						if let projectId = project?.id.toIntId() {
							if let ref = project?.repository?.rootRef {
								NavigationLink(
									"Repository",
									destination: TreeLoader(
										projectId: projectId,
										fullPath: self.fullPath,
										refName: ref
									)
								)

								NavigationLink(
									"Commits",
									destination: CommitsLoader(projectId, refName: ref)
								)
							}

							NavigationLink(
								"Branches",
								destination: BranchesLoader(projectId)
							)

							NavigationLink(
								"Tags",
								destination: TagsLoader(projectId)
							)
						}
					},
					label: {
						Label(
							"Code",
							systemImage:
								"chevron.left.forwardslash.chevron.right")
					})

				DisclosureGroup(
					content: {
						NavigationLink(
							"Pipelines",
							destination: ProjectPipelinesLoader(fullPath: self.fullPath)
						)
						NavigationLink(
							"Releases",
							destination: ProjectReleasesLoader(fullPath: self.fullPath)
						)
					},
					label: {
						Label("Build", systemImage: "flag")
					})
			}

			if let project = self.project {
				let readme = project.repository?.readme?.nodes?.first??.rawTextBlob?.emojized()
				let license = project.repository?.license?.nodes?.first??.rawTextBlob?.emojized()
				let contributing = project.repository?.contributing?.nodes?.first??.rawTextBlob?
					.emojized()

				let baseUrl = URL(string: project.webUrl ?? "")
				let imgUrl = URL(
					string:
						"\(project.webUrl ?? "")/-/raw/\(project.repository?.rootRef ?? "")/"
				)

				if readme != nil || license != nil || contributing != nil {
					Section("Special files") {
						VStack {
							Picker("", selection: $selectedFile) {
								if readme != nil {
									Text("README").tag(0)
								}

								if license != nil {
									Text("LICENSE").tag(1)
								}

								if contributing != nil {
									Text("CONTRIBUTING").tag(2)
								}
							}.pickerStyle(.segmented)

							if selectedFile == 0 && readme != nil {
								Markdown(
									readme!,
									baseURL: baseUrl,
									imageBaseURL: imgUrl
								).markdownTheme(.gitLab)
							} else if selectedFile == 1 && license != nil {
								Markdown(license!)
									.markdownTheme(.gitLab)
							} else if selectedFile == 2 && contributing != nil {
								Markdown(
									contributing!,
									baseURL: baseUrl,
									imageBaseURL: imgUrl
								).markdownTheme(.gitLab)
							}
						}
					}
				}
			}
		}.onAppear {
			loadProject()
		}.refreshable {
			loadProject()
		}.toolbar {
			if let project = self.project {
				Menu(
					content: {
						Section {
							if let url = URL(string: project.webUrl ?? "") {
								ShareButton(url)
							}

							if project.userPermissions.requestAccess {
								Button(
									"Request access",
									systemImage: "person.badge.plus"
								) {
									// TODO: Request access
								}
							}
						}

						let showCloneSection =
							(project.httpUrlToRepo != nil
								|| project.sshUrlToRepo != nil)

						if showCloneSection {
							Section("Clone Code") {
								if let httpUrl = project.httpUrlToRepo {
									Button(
										"Copy HTTP url",
										systemImage: "doc.on.doc"
									) {
										UIPasteboard.general.string = httpUrl
									}
								}

								if let sshUrl = project.sshUrlToRepo {
									Button(
										"Copy SSH url",
										systemImage: "doc.on.doc"
									) {
										UIPasteboard.general.string = sshUrl
									}
								}
							}
						}
					},
					label: {
						Label("More", systemImage: "ellipsis")
							.frame(width: 16, height: 16)
					}
				)
				.menuStyle(.button)
				.buttonStyle(.bordered)
				.clipShape(Circle())

				if project.userPermissions.createIssue {
					RoundIconButton("Create issue", icon: "plus") {
						showNewIssue = true
						Haptics.shared.play(.light)
					}
				}
			}
		}.sheet(isPresented: $showNewIssue) {
			CreateIssueView(showNewIssue: $showNewIssue)
		}
		.navigationTitle(self.fullPath)
		.navigationBarTitleDisplayMode(.inline)
	}
}

#Preview {
	NavigationStack {
		ProjectLoader(fullPath: "felix-schindler/gitlab-ios")
	}
}
