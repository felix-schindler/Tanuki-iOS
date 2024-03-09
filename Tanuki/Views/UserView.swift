//
//  UserView.swift
//  Tanuki
//
//  Created by Felix Schindler on 29.02.24.
//

import GitLabAPI
import MarkdownUI
import SwiftUI

struct UserView: View {
	private let user: User

	init(_ user: User) {
		self.user = user
	}

	public var body: some View {
		VStack(alignment: .leading) {
			HStack {
				if let avatarUrl = URL.fromAvatar(user.avatarUrl) {
					AvatarImage(avatarUrl, size: .medium)
				}
				VStack(alignment: .leading) {
					HStack(spacing: 2) {
						if user.bot {
							Text("🤖")
						}
						Text(user.name)
							.fontWeight(.bold)
					}
					Text("@\(user.username)")
						.foregroundStyle(.secondary)
				}

				if let createdAt = user.createdAt {
					Spacer()
					Text(Date.fromToString(createdAt))
						.font(.footnote)
				}
			}

			ScrollView(.horizontal) {
				HStack {
					if user.location?.isNotEmpty ?? false {
						if let url = URL(
							string:
								"https://maps.apple.com/?q=\(user.location!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")"
						) {
							Link(
								destination: url,
								label: {
									PillView(
										user.location!,
										icon: "mappin.and.ellipse",
										bgColor: .accentColor,
										fgColor: .white,
										cornerRadius: 5
									)
								}
							)
						} else {
							PillView(
								user.location!, icon: "mappin.and.ellipse",
								cornerRadius: 5)
						}
					}

					let hasJob = user.jobTitle != nil
					let hasOrg = user.organization != nil
					if hasJob || hasOrg {
						let workInfo =
							hasJob && hasOrg
							? "\(user.jobTitle!) at \(user.organization!)"
							: "\(user.jobTitle ?? "") \(user.organization ?? "")"
								.trimmingCharacters(in: .whitespaces)
						PillView(
							workInfo,
							icon: "briefcase",
							cornerRadius: 5
						)
					}
				}.font(.footnote)
			}

			ScrollView(.horizontal) {
				HStack {
					if let status = user._status {
						HStack(spacing: 2) {
							if let emoji = status.emoji {
								Text(":\(emoji):".emojized())
							}
							if let message = status.message {
								Text(message.emojized())
							}
						}
						.padding(.horizontal, 8)
						.padding(.vertical, 3)
						.background(Color(.systemGray5))
						.cornerRadius(5)
					}

					if user.pronouns?.isNotEmpty ?? false {
						PillView(user.pronouns!, cornerRadius: 5)
					}
				}.font(.footnote)
			}

			if user.bio?.isNotEmpty ?? false {
				Markdown(user.bio!)
					.markdownTheme(.gitLab)
			}
		}

		if user.state != .active {
			Section {
				switch user.state {
				case .blocked:
					Text(
						"User has been blocked by an administrator and cannot use the system."
					)
				case .deactivated:
					Text("User is no longer active and cannot use the system.")
				case .banned:
					Text("User is blocked, and their contributions are hidden.")
				case .ldapBlocked:
					Text("User has been blocked by the system.")
				case .blockedPendingApproval:
					Text("User is blocked and pending approval.")
				default:
					Text("Unknown user state.")
				}
			}.foregroundStyle(.orange)
		}

		let showMail = user.publicEmail?.isNotEmpty ?? false
		let showIn = user.linkedin?.isNotEmpty ?? false
		let showTwitter = user.twitter?.isNotEmpty ?? false
		let showDiscord = user.discord?.isNotEmpty ?? false

		if showMail || showIn || showTwitter || showDiscord {
			Section("Contact") {
				if showMail {
					Label(user.publicEmail!, systemImage: "envelope")
						.textSelection(.enabled)
				}
				if showIn {
					Text("Linkedin: \(user.linkedin!)")
						.textSelection(.enabled)
				}
				if showTwitter {
					Text("𝕏: \(user.twitter!)")
						.textSelection(.enabled)
				}
				if showDiscord {
					Text("👾 \(user.discord!)")
						.textSelection(.enabled)
				}
			}
		}

		NavigationLink(
			destination: UserIssuesLoader(username: user.username),
			label: {
				Label(
					title: {
						Text("Issues")
					},
					icon: {
						Image(systemName: "smallcircle.circle")
							.foregroundStyle(.green)
					}
				)
			}
		)
		NavigationLink(
			destination: UserGroupsLoader(username: user.username),
			label: {
				Label(
					title: {
						Text("Groups")
						Spacer()
						Text(String(user.groupCount ?? 0))
					},
					icon: {
						Image(systemName: "scale.3d")
							.foregroundStyle(.red)
					})
			})
		NavigationLink(
			destination: UserProjectsLoader(username: user.username),
			label: {
				Label(
					title: {
						Text("Projects")
					},
					icon: {
						Image(systemName: "app.gift.fill")
							.foregroundStyle(.gray)
					})
			})
		NavigationLink(
			destination: UserStarredProjectsLoader(username: user.username),
			label: {
				Label(
					title: {
						Text("Starred projects")
					},
					icon: {
						Image(systemName: "star.fill")
							.foregroundStyle(.yellow)
					})
			})
		NavigationLink(
			destination: UserSnippetsLoader(username: user.username),
			label: {
				Label(
					title: {
						Text("Snippets")
					},
					icon: {
						Image(systemName: "scissors")
							.foregroundStyle(.purple)
					}
				)
			})
		if let id = user.id.toIntId() {
			NavigationLink(
				destination: EventsLoader(userId: id),
				label: {
					Label("Activity", systemImage: "clock.arrow.circlepath")
				}
			)
		}
		NavigationLink(
			destination: TimelogsLoader(
				fullPath: user.username,
				queryType: .group
			),
			label: {
				Label("Timelogs", systemImage: "hourglass")
			}
		)
		NavigationLink(
			destination: UserTodosLoader(username: user.username),
			label: {
				Label("Todos", systemImage: "checkmark.square")
			}
		)
	}
}
