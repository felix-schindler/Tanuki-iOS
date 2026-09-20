//
//  Project.swift
//  Tanuki
//
//  Created by Felix Schindler on 31.10.21.
//  Rewritten by Felix Schindler on 14.03.23 and 26.02.24.
//

import GitLabAPI
//import MarkdownUI
import SwiftUI

enum NavDest {
	case issue,
		milestone,
		release,
		member,
		label
}

struct ProjectLoader: View {
	private let fullPath: String

	@State var project: Result<ProjectQuery.Data.Project, Error>? = nil

	/// Selected special file (README, LICENSE, ...)
	@State var selectedFile = 0

	@State var navigationActive = false

	@State var navigationDestination: NavDest? = nil

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

	private func requestAccess(_ projectId: Int) async {
		do {
			_ = try await API.req(
				type: RestAPIProject.self, method: .post, endpoint: "projects/\(projectId)/access_requests")
			Notify.status(.success, "Access request sent", systemImage: "checkmark")
		} catch {
			Notify.status(.error, "Access request failed", error.localizedDescription, systemImage: "xmark")
		}
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
											Image("git-mr.symbols", bundle: .module)
												.resizable()
												.scaledToFit()
												.frame(width: 20, height: 20)
												.foregroundStyle(.blue)
										}
									)
								}
							)
						}

						if let projectId = project.id.toIntId() {
							#if SKIP_BRIDGE
								Section(header: Label("Manage", systemImage: "person.2")) {
									NavigationLink(
										destination: EventsLoader(projectId: projectId),
										label: {
											Text("Activity")
										})
									NavigationLink(
										"Members",
										destination: MembersLoader(
											fullPath: self.fullPath,
											id: projectId,
											type: .project
										)
									)
									NavigationLink(
										"Labels",
										destination: LabelsLoader(
											fullPath: self.fullPath,
											id: projectId,
											queryType: .project
										)
									)
									NavigationLink(
										"Milestones",
										destination: MilestonesLoader(
											fullPath: self.fullPath,
											id: projectId,
											queryType: .project
										)
									)
								}
							#else
								DisclosureGroup(
									content: {
										NavigationLink(
											destination: EventsLoader(projectId: projectId),
											label: {
												Text("Activity")
											})
										NavigationLink(
											"Members",
											destination: MembersLoader(
												fullPath: self.fullPath,
												id: projectId,
												type: .project
											)
										)
										NavigationLink(
											"Labels",
											destination: LabelsLoader(
												fullPath: self.fullPath,
												id: projectId,
												queryType: .project
											)
										)
										NavigationLink(
											"Milestones",
											destination: MilestonesLoader(
												fullPath: self.fullPath,
												id: projectId,
												queryType: .project
											)
										)
									},
									label: {
										Label("Manage", systemImage: "person.2")
									}
								)
							#endif
						}

						if let projectId = project.id.toIntId() {
							#if SKIP_BRIDGE
								Section(header: Label("Code", systemImage: "chevron.left.forwardslash.chevron.right")) {
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
							#else
								DisclosureGroup(
									content: {
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
									},
									label: {
										Label(
											"Code",
											systemImage: "chevron.left.forwardslash.chevron.right"
										)
									}
								)
							#endif
						}

						#if SKIP_BRIDGE
							Section(header: Label("Build", systemImage: "flag")) {
								NavigationLink(
									"Pipelines",
									destination: ProjectPipelinesLoader(fullPath: self.fullPath)
								)
								NavigationLink(
									"Releases",
									destination: ProjectReleasesLoader(
										fullPath: self.fullPath, projectId: project.id.toIntId())
								)
							}
						#else
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
								}
							)
						#endif
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
									)
								} else if selectedFile == 1 && license != nil {
									Markdown(license!)
								} else if selectedFile == 2 && contributing != nil {
									Markdown(
										contributing!,
										baseURL: baseUrl,
										imageBaseURL: imgUrl
									)
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
			if let project, case .success(let project) = project {
				HStack {
					Menu("More", systemImage: "ellipsis") {
						Section {
							if let webUrl = project.webUrl,
								let url = URL(string: webUrl)
							{
								ShareButton(url)
							}
						}

						if project.userPermissions.requestAccess,
							let projectId = project.id.toIntId()
						{
							Section {
								AsyncButton(
									"Request access",
									systemImage: "person.badge.plus"
								) {
									await requestAccess(projectId)
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
										Notify.status(
											.success, "Copied to clipboard",
											systemImage: "checkmark")
									}
								}

								if let sshUrl = project.sshUrlToRepo {
									Button(
										"Copy SSH url",
										systemImage: "doc.on.doc"
									) {
										sshUrl.copyToClipboard()
										Notify.status(
											.success, "Copied to clipboard",
											systemImage: "checkmark")
									}
								}
							}
						}
					}

					Menu("Create", systemImage: "plus") {
						if project.userPermissions.createIssue {
							Button("Create Issue", systemImage: "smallcircle.circle") {
								navigationActive = true
								navigationDestination = .issue
							}
						}

						Button("Create Milestone", systemImage: "diamond") {
							navigationActive = true
							navigationDestination = .milestone
						}

						Button("Create Release", systemImage: "flag") {
							navigationActive = true
							navigationDestination = .release
						}

						Button("Add new Member", systemImage: "person.badge.plus") {
							navigationActive = true
							navigationDestination = .member
						}

						Button("Create Label", systemImage: "tag") {
							navigationActive = true
							navigationDestination = .label
						}
					}
				}
			}
		}.background {
			#if !SKIP_BRIDGE
				if let project, case .success(let project) = project,
					let projectId = project.id.toIntId()
				{
					NavigationLink(
						isActive: $navigationActive,
						destination: {
							if let navigationDestination {
								switch navigationDestination {
								case .issue:
									NewIssueView(id: projectId, fullPath: self.fullPath)
								case .milestone:
									NewMilestoneView(id: projectId, groupId: 0)
								case .release:
									NewReleaseView(id: projectId, fullPath: self.fullPath)
								case .member:
									NewMemberView(id: projectId, groupId: 0)
								case .label:
									NewLabelView(id: projectId, groupId: 0)
								}
							} else {
								EmptyView()
							}
						},
						label: {
							EmptyView()
						}
					)
				}
			#endif
		}
		.navigationTitle(self.fullPath)
		.navigationBarTitleDisplayMode(.inline)
	}
}
