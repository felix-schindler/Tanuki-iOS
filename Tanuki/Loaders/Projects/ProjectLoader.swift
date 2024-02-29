//
//  Project.swift
//  Tanuki
//
//  Created by Felix Schindler on 26.02.24.
//

import Charts
import GitLabAPI
import MarkdownUI
import NVMColor
import SwiftUI

struct ProjectLoader: View {
	private let fullPath: String
	
	@State
	private var project: GitLabAPI.ProjectQuery.Data.Project? = nil
	
	@State
	private var loadFailed = false
	
	@State
	private var showVerified = false
	
	@State
	private var showNewIssue = false
	
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
	
#if !os(macOS)
	public var body: some View {
		main.navigationBarTitleDisplayMode(.inline)
	}
#else
	public var body: some View {
		main
	}
#endif
	
	var main: some View {
		List {
			Section {
				if let project = self.project {
					VStack(alignment: .leading) {
						HStack {
							if let avatarUrl = URL.fromAvatar(project.avatarUrl)
							{
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
								.markdownTheme(.gitHub)
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
											ForEach(project.topics!, id: \.self)
											{ topic in
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
						}.foregroundStyle(.primary)
							.font(.footnote)
						
						ScrollView(.horizontal) {
							HStack {
								if let namespace = project.namespace {
									// TODO: How do I know whether the namespace is a user or group
									NavigationLink(
										destination: NamespaceLoader(
											fullPath: namespace.fullPath),
										label: {
											Label(
												namespace.name,
												systemImage: "person"
											)
											.foregroundStyle(.primary)
										}
									)
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
				} else if loadFailed {
					Text(LOAD_FAILED)
				} else {
					VStack(alignment: .center) {
						ProgressView("Loading project")
					}.frame(maxWidth: .infinity, minHeight: 250)
				}
			}
			
			if let lastCommit = project?.repository?.tree?.lastCommit {
				Section("Last commit") {
					HStack {
						VStack(alignment: .leading) {
							if let title = lastCommit.title {
								Text(title)
							}
							
							if lastCommit.authorName != nil
								&& lastCommit.authoredDate != nil
							{
								Text(
									"\(lastCommit.authorName!) authored at \(Date.fromToString(lastCommit.authoredDate!))"
								)
								.font(.footnote)
							}
						}
						
						Spacer()
						
						VStack {
							HStack {
								if lastCommit.pipelines?.nodes != nil
									&& lastCommit.pipelines!.nodes!.count > 0
								{
									PipelineStatus(
										lastCommit.pipelines!.nodes![0]!.status)
								}
								
								if lastCommit.signature?.verificationStatus?
									.rawValue.starts(with: "VERIFIED") ?? false
								{
									RoundIconButton(
										"Verified", icon: "checkmark.seal"
									) {
										Haptics.shared.play(.light)
										showVerified = true
									}.tint(.green)
										.controlSize(.mini)
								}
							}
							
							Text(lastCommit.shortId)
								.font(.system(.footnote, design: .monospaced))
						}
					}
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
						Text("Activity")
						Text("Members")
						Text("Labels")
						Text("Milestones")
					},
					label: {
						Label("Manage", systemImage: "person.2")
					})
				
				DisclosureGroup(
					content: {
						Text("Repository")
						Text("Branches")
						Text("Commits")
						Text("Tags")
					},
					label: {
						Label(
							"Code",
							systemImage:
								"chevron.left.forwardslash.chevron.right")
					})
				
				DisclosureGroup(
					content: {
						Text("Pipelines")
						Text("Releases")
					},
					label: {
						Label("Build", systemImage: "flag")
					})
			}.foregroundStyle(.primary)
			
			if let readmeContent = project?.repository?.blobs?.nodes?.first??
				.rawTextBlob
			{
				Section("README") {
					Markdown(readmeContent.emojized())
						.markdownTheme(.gitHub)
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
		}.sheet(isPresented: $showVerified) {
			VStack(alignment: .leading) {
				HStack {
					Text("Verified commit")
						.font(.title)
						.fontWeight(.bold)
					Spacer()
					CloseButton {
						showVerified = false
					}
				}
				Text(
					"This commit was signed with a verified signature and the committer email was verified to belong to the same user."
				)
				Spacer()
			}.padding()
				.presentationDetents([.fraction(0.2)])
		}.sheet(isPresented: $showNewIssue) {
			CreateIssueView(showNewIssue: $showNewIssue)
		}.navigationTitle(self.fullPath)
	}
}

#Preview {
	NavigationStack {
		ProjectLoader(fullPath: "felix-schindler/gitlab-ios")
	}
}
