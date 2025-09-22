//
//  Project.swift
//  Tanuki
//
//  Created by Felix Schindler on 31.10.21.
//  Rewritten by Felix Schindler on 14.03.23 and 26.02.24.
//

import GitLabAPI
import MarkdownUI
import NVMColor
import SwiftUI

struct ProjectLoader: View {
	private let fullPath: String

	@State
	private var project: Result<ProjectQuery.Data.Project, Error>? = nil

	/// Selected special file (README, LICENSE, ...)
	@State
	private var selectedFile = 0

	init(fullPath: String) {
		self.fullPath = fullPath
	}

	private func loadProject() {
		do {
			let responses = try Network.shared.apollo.fetch(
				query: ProjectQuery(fullPath: fullPath),
				cachePolicy: .cacheAndNetwork
			)

			Task {
				for try await response in responses {
					if let project = response.data?.project {
						self.project = .success(project)
					} else if let errors = response.errors {
						for error in errors {
							Notify.status(.error, error.localizedDescription)
						}
					}
				}
			}
		} catch let error {
			self.project = .failure(error)
			Notify.status(.error)
		}
	}

	private func reloadProject() async {
		do {
			let response = try await Network.shared.apollo.fetch(
				query: ProjectQuery(fullPath: fullPath),
				cachePolicy: .networkOnly
			)

			if let project = response.data?.project {
				self.project = .success(project)
			}

			Notify.status(.success)
		} catch let error {
			self.project = .failure(error)
			Notify.status(.error)
		}
	}

	private func requestAccess() async {
	}

	public var body: some View {
		List {
			if let project {
				switch project {
				case .success(let project):
					Section {
						ProjectHeaderView(project)
					}

					if let lastCommit = project.repository?.tree?.lastCommit,
						let projectId = project.id.toIntId()
					{
						Section("Last commit") {
							SmallCommitView(lastCommit, projectId)
						}
					}

					Section("Actions") {
						if project.issuesEnabled ?? true {
							NavigationLink(
								destination: ProjectIssuesLoader(
									fullPath: self.fullPath
								),
								label: {
									Label(
										title: {
											HStack {
												Text("Issues")
												Spacer()
												Text("\(project.openIssuesCount ?? 0)")
											}
										},
										icon: {
											Image(systemName: "smallcircle.circle")
												.foregroundStyle(.green)
										})
								}
							)
						}

						if project.mergeRequestsEnabled ?? true {
							NavigationLink(
								destination: ProjectMergeLoader(fullPath: self.fullPath),
								label: {
									Label(
										title: {
											HStack {
												Text("Merge Requests")
												Spacer()
												Text(
													"\(project.openMergeRequestsCount ?? 0)"
												)
											}
										},
										icon: {
											Image(systemName: "arrow.triangle.pull")
												.foregroundStyle(.blue)
										}
									)
								}
							)
						}

						DisclosureGroup(
							content: {
								if let projectId = project.id.toIntId() {
									NavigationLink(
										destination: EventsLoader(projectId: projectId),
										label: {
											Text("Activity")
										})
								}
								NavigationLink(
									"Members",
									destination: MembersLoader(
										fullPath: self.fullPath, type: .project)
								)
								NavigationLink(
									"Labels",
									destination: LabelsLoader(
										fullPath: self.fullPath, queryType: .project)
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
								if let projectId = project.id.toIntId() {
									if let ref = project.repository?.rootRef {
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
									destination: ProjectReleasesLoader(
										fullPath: self.fullPath, projectId: project.id.toIntId())
								)
							},
							label: {
								Label("Build", systemImage: "flag")
							})
					}

					let readme = project.repository?.readme?.nodes?.first??
						.rawTextBlob?
						.emojized()
					let license = project.repository?.license?.nodes?.first??
						.rawTextBlob?
						.emojized()
					let contributing = project.repository?.contributing?.nodes?.first??
						.rawTextBlob?
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
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading Project \(self.fullPath)", systemImage: "app.gift.fill")
			}
		}.onAppear {
			loadProject()
		}.refreshable {
			await reloadProject()
		}.toolbar {
			HStack {
				if let project, case .success(let project) = project {
					Menu("More", systemImage: "ellipsis") {
						Section {
							if let webUrl = project.webUrl,
								let url = URL(string: webUrl)
							{
								ShareButton(url)
							}

							if project.userPermissions.requestAccess {
								AsyncButton(
									"Request access",
									systemImage: "person.badge.plus"
								) {
									await requestAccess()
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
										httpUrl.copyToClipboard()
									}
								}

								if let sshUrl = project.sshUrlToRepo {
									Button(
										"Copy SSH url",
										systemImage: "doc.on.doc"
									) {
										sshUrl.copyToClipboard()
									}
								}
							}
						}
					}

					if let projectId = project.id.toIntId() {
						Menu("Create", systemImage: "plus") {
							if project.userPermissions.createIssue {
								NavigationLink(
									destination: NewIssueView(id: projectId),
									label: {
										Label("Create Issue", systemImage: "smallcircle.circle")
									}
								)
							}

							NavigationLink(
								destination: NewLabelView(id: projectId, groupId: 0),
								label: {
									Label("Create Milestone", systemImage: "flag.circle")
								}
							)

							NavigationLink(
								destination: NewLabelView(id: projectId, groupId: 0),
								label: {
									Label("Create Release", systemImage: "flag")
								}
							)

							NavigationLink(
								destination: NewMemberView(id: projectId, groupId: 0),
								label: {
									Label("Add new member", systemImage: "person.badge.plus")
								}
							)

							if project.userPermissions.createLabel {
								NavigationLink(
									destination: NewLabelView(id: projectId, groupId: 0),
									label: {
										Label("Create Label", systemImage: "tag")
									}
								)
							}
						}
					}
				}
			}
		}
		.navigationTitle(self.fullPath)
		.navigationBarTitleDisplayMode(.inline)
	}
}

#Preview {
	NavigationView {
		ProjectLoader(fullPath: "felix-schindler/gitlab-ios")
	}
}
