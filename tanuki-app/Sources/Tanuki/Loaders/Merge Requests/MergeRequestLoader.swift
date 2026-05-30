//
//  MergeRequest.swift
//  Tanuki
//
//  Created by Felix Schindler on 27.02.24.
//

import GitLabAPI
import SwiftUI

private extension MergeRequest_Project_MergeRequest_Author {
	var toMyAuthor: MyAuthor {
		MyAuthor(avatarUrl: avatarUrl, name: name ?? username ?? "", username: username ?? "")
	}
}

private extension MergeRequest_Project_MergeRequest_Notes_Nodes_Author {
	var toMyAuthor: MyAuthor {
		MyAuthor(avatarUrl: avatarUrl, name: name ?? username ?? "", username: username ?? "")
	}
}

private struct NoteWrapper: Note {
	let note: MergeRequest_Project_MergeRequest_Notes_Nodes

	var system: Bool { note.system == "true" }
	var systemNoteIconName: String? { note.systemNoteIconName }
	var body: String { note.body ?? "" }
	var _author: MyAuthor? {
		guard let author = note.author else { return nil }
		return author.toMyAuthor
	}
	var createdAt: String { note.createdAt ?? "" }
	var updatedAt: String { note.updatedAt ?? "" }
	var maxAccessLevelOfAuthor: String? { note.maxAccessLevelOfAuthor }
}

struct MergeRequestLoader: View {
	@Environment(\.dismiss) var dismiss

	private let fullPath: String
	private let iid: String

	@State var project: Result<MergeRequest_Project, Error>? = nil

	init(fullPath: String, iid: String) {
		self.fullPath = fullPath
		self.iid = iid
	}

	private func loadMergeRequest() {
		Task {
			do {
				let project = try await Network.shared.service.fetchMergeRequest(fullPath: self.fullPath, iid: self.iid)
				self.project = .success(project)
			} catch let error {
				self.project = .failure(error)
				Notify.status(.error)
			}
		}
	}

	private func reloadMergeRequest() async {
		do {
			let project = try await Network.shared.service.fetchMergeRequest(fullPath: self.fullPath, iid: self.iid, strategy: .networkOnly)
			self.project = .success(project)
			Notify.status(.success)
		} catch let error {
			self.project = .failure(error)
			Notify.status(.error)
		}
	}

	private func approve(_ projectId: Int) async {
		do {
			_ = try await API.req(
				type: RestAPIMergeRequest.self, method: .post,
				endpoint: "projects/\(projectId)/merge_requests/\(self.iid)/approve")
			await reloadMergeRequest()
		} catch let error {
			Notify.status(.error, "Failed to approve", error.localizedDescription)
		}
	}

	private func unapprove(_ projectId: Int) async {
		do {
			_ = try await API.req(
				type: RestAPIMergeRequest.self, method: .post,
				endpoint: "projects/\(projectId)/merge_requests/\(self.iid)/unapprove")
			await reloadMergeRequest()
		} catch let error {
			Notify.status(.error, "Failed to unapprove", error.localizedDescription)
		}
	}

	private func changeState(_ projectId: Int, state: String) async {
		var body: [String: EncodableValue] = [:]
		body["state_event"] = .string(state)

		do {
			_ = try await API.req(
				type: RestAPIMergeRequest.self,
				method: .put,
				endpoint: "projects/\(projectId)/merge_requests/\(self.iid)",
				body: body
			)
			await reloadMergeRequest()
		} catch let error {
			Notify.status(.error, "Failed to change state", error.localizedDescription)
		}
	}

	private func remove(_ projectId: Int) async {
		do {
			_ = try await API.delete(endpoint: "projects/\(projectId)/merge_requests/\(self.iid)")
			dismiss()
		} catch let error {
			Notify.status(.error, "Failed to delete MR", error.localizedDescription)
		}
	}

	public var body: some View {
		List {
			if let project {
				switch project {
				case .success(let project):
					if let mr = project.mergeRequest {
						VStack(alignment: .leading) {
							HStack(spacing: 5) {
								if let url = URL.fromAvatar(project.avatarUrl) {
									AvatarImage(url, size: .tiny)
								}
								ScrollView(.horizontal) {
									Text(mr.reference ?? "")
										.foregroundStyle(.secondary)
								}
								Spacer()
								Text(Date.fromToString(mr.createdAt ?? ""))
							}
							.font(.footnote)
							.padding(.bottom, 1)

							Text(mr.title?.emojized() ?? "")
								.font(.title3)
								.fontWeight(.medium)
								.padding(.bottom, 1)

							ScrollView(.horizontal) {
								HStack(spacing: 5) {
									if let author = mr.author {
										ScrollView(.horizontal) {
											AuthorView(author.toMyAuthor)
										}
									}

									if let sourceProject = mr.sourceProject,
										sourceProject.fullPath != self.fullPath
									{
										NavigationLink(
											destination: ProjectLoader(
												fullPath: sourceProject.fullPath
											),
											label: {
												PillView(
													"\(sourceProject.fullPath)/\(mr.sourceBranch ?? "")",
													bgColor: .blue,
													fgColor: .white,
													cornerRadius: 5
												)
												.font(.system(.footnote, design: .monospaced))
												.textSelection(.enabled)
											}
										)
									} else {
										PillView(
											mr.sourceBranch ?? "",
											bgColor: .blue,
											fgColor: .white,
											cornerRadius: 5
										)
										.font(.system(.footnote, design: .monospaced))
										.textSelection(.enabled)
									}

									Image(systemName: "arrow.right")

									PillView(
										mr.targetBranch ?? "",
										bgColor: .blue,
										fgColor: .white,
										cornerRadius: 5
									)
									.font(.system(.footnote, design: .monospaced))
									.textSelection(.enabled)
								}
							}.font(.footnote)

							if let description = mr.description?.emojized(),
								description.isNotEmpty
							{
								Markdown(description)
									.markdownTheme(.gitLab)
							}

							HStack {
								PillView(String(Int(mr.upvotes ?? "0") ?? 0), icon: "hand.thumbsup")
								PillView(String(Int(mr.downvotes ?? "0") ?? 0), icon: "hand.thumbsdown")
							}
							.modifier(LabelSpacingIfAvailable())
							.font(.footnote)
						}

						Section("Details") {
							let assgineeCount = mr.assignees?.nodes?.count ?? 0
							DisclosureGroup(
								content: {
									if assgineeCount > 0 {
										ForEach(mr.assignees!.nodes!, id: \.username) { user in
											NavigationLink(
												destination: UserLoader(
													username: user.username ?? ""),
												label: {
													HStack {
														if let url =
															URL.fromAvatar(
																user.avatarUrl)
														{
															AvatarImage(
																url,
																size: .small)
														}
														Text(user.username ?? "")
													}
												}
											)
										}
									} else {
										Text("There are no assignees")
									}
								},
								label: {
									Label(
										title: {
											HStack {
												Text("Assignees")
												Spacer()
												Text("\(assgineeCount)")
											}
										},
										icon: {
											Image(systemName: "person.crop.circle")
										})
								}
							)

							let reviewerCount = mr.reviewers?.nodes?.count ?? 0
							DisclosureGroup(
								content: {
									if reviewerCount > 0 {
										ForEach(mr.reviewers!.nodes!, id: \.username) { user in
											NavigationLink(
												destination: UserLoader(
													username: user.username ?? ""),
												label: {
													HStack {
														if let url = URL.fromAvatar(user.avatarUrl) {
															AvatarImage(url, size: .small)
														}
														Text(user.username ?? "")
													}
												}
											)
										}
									} else {
										Text("There are no reviewers")
									}
								},
								label: {
									Label(
										title: {
											HStack {
												Text("Reviewers")
												Spacer()
												Text("\(reviewerCount)")
											}
										},
										icon: {
											Image(
												systemName:
													"person.line.dotted.person.fill"
											)
										})
								}
							)

							if let labels = mr.labels?.nodes, labels.isNotEmpty {
								Label(
									title: {
										ScrollView(.horizontal) {
											HStack {
												ForEach(labels, id: \.title) { label in
													PillView(
														label.title ?? "",
														bgColor: Color(hex: label.color ?? ""),
														fgColor: Color(hex: label.textColor ?? "")
													)
												}
											}
										}
									},
									icon: {
										Image(systemName: "tag")
									}
								)
							}

							if let milestone = mr.milestone {
								Label(
									milestone.title ?? "",
									systemImage: "diamond"
								)
							}

							if mr.humanTimeEstimate != nil
								|| mr.humanTotalTimeSpent != nil
							{
								Label(
									title: {
										HStack {
											Text("Estimate: \(mr.humanTimeEstimate ?? "none")")
											Spacer()
											Text("Spent: \(mr.humanTotalTimeSpent ?? "none")")
										}
									},
									icon: {
										Image(systemName: "hourglass")
									}
								)
							}
						}

						Section("Changes") {
							let projectId = project.id?.toIntId()
							let iid = self.iid.toIntId()
							NavigationLink(
								destination: DiffLoader(
									projectId: projectId ?? 0,
									mrIid: iid ?? 0
								),
								label: {
									if let diffStats = mr.diffStatsSummary {
										Label(
											title: {
												HStack {
													Text("\(Int(diffStats.fileCount ?? "0") ?? 0) files changed")
													Spacer()
													HStack {
														Text("+\(Int(diffStats.additions ?? "0") ?? 0)")
															.foregroundStyle(.green)
														Text("-\(Int(diffStats.deletions ?? "0") ?? 0)")
															.foregroundStyle(.red)
													}.font(.system(.body, design: .monospaced))
												}
											},
											icon: {
												Image(systemName: "doc.text")
											}
										)
									} else {
										Text("Diff")
									}
								}
							).disabled(projectId == nil || iid == 0)

							NavigationLink(
								destination: DiffsStatsLoader(
									fullPath: self.fullPath,
									iid: self.iid
								),
								label: {
									Label("Changed files overview", systemImage: "plusminus")
								}
							)

							NavigationLink(
								destination: MrCommitsLoader(
									fullPath: self.fullPath,
									iid: self.iid
								),
								label: {
									Label("Commits", systemImage: "circle.and.line.horizontal")
								}
							)
						}

						let showMergeSection =
							(mr.userPermissions?.canApprove == "true"
								|| mr.userPermissions?.canMerge == "true"
								|| mr.userPermissions?.updateMergeRequest == "true")
						if showMergeSection,
							let projectId = project.id?.toIntId()
						{
							Section("Actions") {
								if mr.userPermissions?.canMerge == "true" {
									MergeButton(
										iid: mr.iid ?? "",
										projectId: projectId,
										onMerge: {
											await reloadMergeRequest()
										},
										hasConflicts: mr.conflicts == "true",
										mergeStatusEnum: MergeStatus(rawValue: mr.mergeStatusEnum ?? "") ?? .canBeMerged,
										detailedMergeStatus: DetailedMergeStatus(rawValue: mr.detailedMergeStatus ?? "")
									)
								}

								if mr.userPermissions?.canApprove == "true" {
									AsyncButton(
										"Approve",
										systemImage: "person.fill.checkmark"
									) {
										await approve(projectId)
									}.tint(.green)
								} else if mr.approved == "true" {
									AsyncButton(
										"Revoke approval",
										systemImage: "person.fill.xmark"
									) {
										await unapprove(projectId)
									}.tint(.red)
								}

								if mr.userPermissions?.updateMergeRequest == "true" {
									if mr.state == "opened" {
										AsyncButton(
											action: {
												await changeState(projectId, state: "close")
											},
											label: {
												Label(
													title: {
														Text("Close MR")
													},
													icon: {
														Image("git-mr-closed.symbols")
															.resizable()
															.scaledToFit()
													})
											}
										).tint(.blue)
									} else if mr.state == "closed" {
										AsyncButton(
											action: {
												await changeState(projectId, state: "reopen")
											},
											label: {
												Label(
													title: {
														Text("Reopen MR")
													},
													icon: {
														Image("git-mr.symbols")
															.resizable()
															.scaledToFit()
													})
											}
										).tint(.green)
									}

									AsyncButton("Delete MR", systemImage: "trash") {
										await remove(projectId)
									}.tint(.red)
								}
							}
						}

						let noteCount = mr.notes?.nodes?.count ?? 0
						if mr.userPermissions?.createNote == "true" || noteCount > 0 {
							Section("Notes (\(mr.userNotesCount ?? "0"))") {
								if let projectId = project.id?.toIntId(),
									mr.userPermissions?.createNote == "true"
								{
									NewNoteView(projectId, iid: mr.iid ?? "", type: .mergeRequest)
								}

								if noteCount > 0 {
									ForEach(mr.notes!.nodes!, id: \.id) { note in
										NoteView(NoteWrapper(note: note), projectId: project.id?.toIntId() ?? 0)
									}
								}
							}
						}
					} else {
						NoContentView("Can't find merge request", image: "git-mr.symbols")
					}
				case .failure(let error):
					FailedView(error)
				}
			} else {
				LoadingView("Loading Merge Request !\(self.iid)", image: "git-mr.symbols", color: .blue)
			}
		}.onAppear {
			loadMergeRequest()
		}.refreshable {
			await reloadMergeRequest()
		}.toolbar {
			if let project, case .success(let project) = project {
				if let mr = project.mergeRequest {
					HStack {
						Button(
							action: {},
							label: {
								Label(
									title: {
										Text(mr.state?.capitalized ?? "")
									},
									icon: {
										MergeStateHelper.getIconByState(MergeRequestState(rawValue: mr.state ?? "") ?? .opened)
											.resizable()
											.scaledToFit()
									})
							}
						)
						.tint(MergeStateHelper.getColorByState(MergeRequestState(rawValue: mr.state ?? "") ?? .opened))
						.labelStyle(.titleAndIcon)
						.buttonBorderShape(.roundedRectangle)
						.buttonStyle(.borderedProminent)
						.controlSize(.mini)

						if let webUrl = mr.webUrl,
							let url = URL(string: webUrl)
						{
							ShareButton(url)
						}
					}
				}
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.modifier(ScrollDismissIfAvailable())
	}
}

#Preview {
	NavigationView {
		MergeRequestLoader(fullPath: "felix-schindler/gitlab-ios", iid: "1")
	}
}
