// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct EpicQuery: GraphQLQuery {
	public static let operationName: String = "Epic"
	public static let operationDocument: ApolloAPI.OperationDocument = .init(
		definition: .init(
			#"query Epic($fullPath: ID!, $iid: ID!) { group(fullPath: $fullPath) { __typename id avatarUrl epic(iid: $iid) { __typename iid title description reference(full: true) state dueDate createdAt webUrl startDate dueDate color textColor upvotes downvotes userNotesCount author { __typename avatarUrl name username } ancestors { __typename nodes { __typename iid } } blockedByEpics { __typename nodes { __typename iid } } children { __typename nodes { __typename iid } } userPermissions { __typename updateEpic createNote } labels { __typename nodes { __typename title color textColor } } notes { __typename nodes { __typename id author { __typename avatarUrl name username } maxAccessLevelOfAuthor body system systemNoteIconName createdAt updatedAt } } } } }"#
		))

	public var fullPath: ID
	public var iid: ID

	public init(
		fullPath: ID,
		iid: ID
	) {
		self.fullPath = fullPath
		self.iid = iid
	}

	@_spi(Unsafe) public var __variables: Variables? {
		[
			"fullPath": fullPath,
			"iid": iid,
		]
	}

	nonisolated public struct Data: GitLabAPI.SelectionSet {
		@_spi(Unsafe) public let __data: DataDict
		@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

		@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Query }
		@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
			[
				.field("group", Group?.self, arguments: ["fullPath": .variable("fullPath")])
			]
		}
		@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
			[
				EpicQuery.Data.self
			]
		}

		/// Find a group.
		public var group: Group? { __data["group"] }

		/// Group
		///
		/// Parent Type: `Group`
		nonisolated public struct Group: GitLabAPI.SelectionSet {
			@_spi(Unsafe) public let __data: DataDict
			@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

			@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Group }
			@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
				[
					.field("__typename", String.self),
					.field("id", GitLabAPI.ID?.self),
					.field("avatarUrl", String?.self),
					.field("epic", Epic?.self, arguments: ["iid": .variable("iid")]),
				]
			}
			@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
				[
					EpicQuery.Data.Group.self
				]
			}

			/// ID of the group.
			public var id: GitLabAPI.ID? { __data["id"] }
			/// Avatar URL of the group.
			public var avatarUrl: String? { __data["avatarUrl"] }
			/// Find a single epic. Deprecated in GitLab 17.5: Replaced by `WorkItem` type. For more information, see [migration guide](https://docs.gitlab.com/api/graphql/epic_work_items_api_migration_guide/).
			@available(
				*, deprecated,
				message:
					"Replaced by `WorkItem` type. For more information, see [migration guide](https://docs.gitlab.com/api/graphql/epic_work_items_api_migration_guide/). Deprecated in GitLab 17.5."
			)
			public var epic: Epic? { __data["epic"] }

			/// Group.Epic
			///
			/// Parent Type: `Epic`
			nonisolated public struct Epic: GitLabAPI.SelectionSet {
				@_spi(Unsafe) public let __data: DataDict
				@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

				@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Epic }
				@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
					[
						.field("__typename", String.self),
						.field("iid", String.self),
						.field("title", String?.self),
						.field("description", String?.self),
						.field("reference", String.self, arguments: ["full": true]),
						.field("state", GraphQLEnum<GitLabAPI.EpicState>.self),
						.field("dueDate", GitLabAPI.Time?.self),
						.field("createdAt", GitLabAPI.Time?.self),
						.field("webUrl", String.self),
						.field("startDate", GitLabAPI.Time?.self),
						.field("color", String?.self),
						.field("textColor", String?.self),
						.field("upvotes", Int.self),
						.field("downvotes", Int.self),
						.field("userNotesCount", Int.self),
						.field("author", Author.self),
						.field("ancestors", Ancestors?.self),
						.field("blockedByEpics", BlockedByEpics?.self),
						.field("children", Children?.self),
						.field("userPermissions", UserPermissions.self),
						.field("labels", Labels?.self),
						.field("notes", Notes.self),
					]
				}
				@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
					[
						EpicQuery.Data.Group.Epic.self
					]
				}

				/// Internal ID of the epic.
				public var iid: String { __data["iid"] }
				/// Title of the epic.
				public var title: String? { __data["title"] }
				/// Description of the epic.
				public var description: String? { __data["description"] }
				/// Internal reference of the epic. Returned in shortened format by default.
				public var reference: String { __data["reference"] }
				/// State of the epic.
				public var state: GraphQLEnum<GitLabAPI.EpicState> { __data["state"] }
				/// Due date of the epic.
				public var dueDate: GitLabAPI.Time? { __data["dueDate"] }
				/// Timestamp of when the epic was created.
				public var createdAt: GitLabAPI.Time? { __data["createdAt"] }
				/// Web URL of the epic.
				public var webUrl: String { __data["webUrl"] }
				/// Start date of the epic.
				public var startDate: GitLabAPI.Time? { __data["startDate"] }
				/// Color of the epic.
				public var color: String? { __data["color"] }
				/// Text color generated for the epic.
				public var textColor: String? { __data["textColor"] }
				/// Number of upvotes the epic has received.
				public var upvotes: Int { __data["upvotes"] }
				/// Number of downvotes the epic has received.
				public var downvotes: Int { __data["downvotes"] }
				/// Number of user notes of the epic.
				public var userNotesCount: Int { __data["userNotesCount"] }
				/// Author of the epic.
				public var author: Author { __data["author"] }
				/// Ancestors (parents) of the epic.
				public var ancestors: Ancestors? { __data["ancestors"] }
				/// Epics blocking the epic.
				public var blockedByEpics: BlockedByEpics? { __data["blockedByEpics"] }
				/// Children (sub-epics) of the epic.
				public var children: Children? { __data["children"] }
				/// Permissions for the current user on the resource
				public var userPermissions: UserPermissions { __data["userPermissions"] }
				/// Labels assigned to the epic.
				public var labels: Labels? { __data["labels"] }
				/// All notes on this noteable.
				public var notes: Notes { __data["notes"] }

				/// Group.Epic.Author
				///
				/// Parent Type: `UserCore`
				nonisolated public struct Author: GitLabAPI.SelectionSet {
					@_spi(Unsafe) public let __data: DataDict
					@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

					@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.UserCore }
					@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
						[
							.field("__typename", String.self),
							.field("avatarUrl", String?.self),
							.field("name", String.self),
							.field("username", String.self),
						]
					}
					@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
						[
							EpicQuery.Data.Group.Epic.Author.self
						]
					}

					/// URL of the user's avatar.
					public var avatarUrl: String? { __data["avatarUrl"] }
					/// Human-readable name of the user. Returns `****` if the user is a project bot and the requester does not have permission to view the project.
					public var name: String { __data["name"] }
					/// Username of the user. Unique within the instance of GitLab.
					public var username: String { __data["username"] }
				}

				/// Group.Epic.Ancestors
				///
				/// Parent Type: `EpicConnection`
				nonisolated public struct Ancestors: GitLabAPI.SelectionSet {
					@_spi(Unsafe) public let __data: DataDict
					@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

					@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.EpicConnection }
					@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
						[
							.field("__typename", String.self),
							.field("nodes", [Node?]?.self),
						]
					}
					@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
						[
							EpicQuery.Data.Group.Epic.Ancestors.self
						]
					}

					/// A list of nodes.
					public var nodes: [Node?]? { __data["nodes"] }

					/// Group.Epic.Ancestors.Node
					///
					/// Parent Type: `Epic`
					nonisolated public struct Node: GitLabAPI.SelectionSet {
						@_spi(Unsafe) public let __data: DataDict
						@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

						@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Epic }
						@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
							[
								.field("__typename", String.self),
								.field("iid", String.self),
							]
						}
						@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
							[
								EpicQuery.Data.Group.Epic.Ancestors.Node.self
							]
						}

						/// Internal ID of the epic.
						public var iid: String { __data["iid"] }
					}
				}

				/// Group.Epic.BlockedByEpics
				///
				/// Parent Type: `EpicConnection`
				nonisolated public struct BlockedByEpics: GitLabAPI.SelectionSet {
					@_spi(Unsafe) public let __data: DataDict
					@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

					@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.EpicConnection }
					@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
						[
							.field("__typename", String.self),
							.field("nodes", [Node?]?.self),
						]
					}
					@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
						[
							EpicQuery.Data.Group.Epic.BlockedByEpics.self
						]
					}

					/// A list of nodes.
					public var nodes: [Node?]? { __data["nodes"] }

					/// Group.Epic.BlockedByEpics.Node
					///
					/// Parent Type: `Epic`
					nonisolated public struct Node: GitLabAPI.SelectionSet {
						@_spi(Unsafe) public let __data: DataDict
						@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

						@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Epic }
						@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
							[
								.field("__typename", String.self),
								.field("iid", String.self),
							]
						}
						@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
							[
								EpicQuery.Data.Group.Epic.BlockedByEpics.Node.self
							]
						}

						/// Internal ID of the epic.
						public var iid: String { __data["iid"] }
					}
				}

				/// Group.Epic.Children
				///
				/// Parent Type: `EpicConnection`
				nonisolated public struct Children: GitLabAPI.SelectionSet {
					@_spi(Unsafe) public let __data: DataDict
					@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

					@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.EpicConnection }
					@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
						[
							.field("__typename", String.self),
							.field("nodes", [Node?]?.self),
						]
					}
					@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
						[
							EpicQuery.Data.Group.Epic.Children.self
						]
					}

					/// A list of nodes.
					public var nodes: [Node?]? { __data["nodes"] }

					/// Group.Epic.Children.Node
					///
					/// Parent Type: `Epic`
					nonisolated public struct Node: GitLabAPI.SelectionSet {
						@_spi(Unsafe) public let __data: DataDict
						@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

						@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Epic }
						@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
							[
								.field("__typename", String.self),
								.field("iid", String.self),
							]
						}
						@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
							[
								EpicQuery.Data.Group.Epic.Children.Node.self
							]
						}

						/// Internal ID of the epic.
						public var iid: String { __data["iid"] }
					}
				}

				/// Group.Epic.UserPermissions
				///
				/// Parent Type: `EpicPermissions`
				nonisolated public struct UserPermissions: GitLabAPI.SelectionSet {
					@_spi(Unsafe) public let __data: DataDict
					@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

					@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.EpicPermissions }
					@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
						[
							.field("__typename", String.self),
							.field("updateEpic", Bool.self),
							.field("createNote", Bool.self),
						]
					}
					@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
						[
							EpicQuery.Data.Group.Epic.UserPermissions.self
						]
					}

					/// If `true`, the user can perform `update_epic` on this resource
					public var updateEpic: Bool { __data["updateEpic"] }
					/// If `true`, the user can perform `create_note` on this resource
					public var createNote: Bool { __data["createNote"] }
				}

				/// Group.Epic.Labels
				///
				/// Parent Type: `LabelConnection`
				nonisolated public struct Labels: GitLabAPI.SelectionSet {
					@_spi(Unsafe) public let __data: DataDict
					@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

					@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.LabelConnection }
					@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
						[
							.field("__typename", String.self),
							.field("nodes", [Node?]?.self),
						]
					}
					@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
						[
							EpicQuery.Data.Group.Epic.Labels.self
						]
					}

					/// A list of nodes.
					public var nodes: [Node?]? { __data["nodes"] }

					/// Group.Epic.Labels.Node
					///
					/// Parent Type: `Label`
					nonisolated public struct Node: GitLabAPI.SelectionSet {
						@_spi(Unsafe) public let __data: DataDict
						@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

						@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Label }
						@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
							[
								.field("__typename", String.self),
								.field("title", String.self),
								.field("color", String.self),
								.field("textColor", String.self),
							]
						}
						@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
							[
								EpicQuery.Data.Group.Epic.Labels.Node.self
							]
						}

						/// Content of the label.
						public var title: String { __data["title"] }
						/// Background color of the label.
						public var color: String { __data["color"] }
						/// Text color of the label.
						public var textColor: String { __data["textColor"] }
					}
				}

				/// Group.Epic.Notes
				///
				/// Parent Type: `NoteConnection`
				nonisolated public struct Notes: GitLabAPI.SelectionSet {
					@_spi(Unsafe) public let __data: DataDict
					@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

					@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.NoteConnection }
					@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
						[
							.field("__typename", String.self),
							.field("nodes", [Node?]?.self),
						]
					}
					@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
						[
							EpicQuery.Data.Group.Epic.Notes.self
						]
					}

					/// A list of nodes.
					public var nodes: [Node?]? { __data["nodes"] }

					/// Group.Epic.Notes.Node
					///
					/// Parent Type: `Note`
					nonisolated public struct Node: GitLabAPI.SelectionSet {
						@_spi(Unsafe) public let __data: DataDict
						@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

						@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Note }
						@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
							[
								.field("__typename", String.self),
								.field("id", GitLabAPI.NoteID.self),
								.field("author", Author?.self),
								.field("maxAccessLevelOfAuthor", String?.self),
								.field("body", String.self),
								.field("system", Bool.self),
								.field("systemNoteIconName", String?.self),
								.field("createdAt", GitLabAPI.Time.self),
								.field("updatedAt", GitLabAPI.Time.self),
							]
						}
						@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
							[
								EpicQuery.Data.Group.Epic.Notes.Node.self
							]
						}

						/// ID of the note.
						public var id: GitLabAPI.NoteID { __data["id"] }
						/// User who wrote the note.
						public var author: Author? { __data["author"] }
						/// Max access level of the note author in the project.
						public var maxAccessLevelOfAuthor: String? { __data["maxAccessLevelOfAuthor"] }
						/// Content of the note.
						public var body: String { __data["body"] }
						/// Indicates whether the note was created by the system or by a user.
						public var system: Bool { __data["system"] }
						/// Name of the icon corresponding to a system note.
						public var systemNoteIconName: String? { __data["systemNoteIconName"] }
						/// Timestamp of the note creation.
						public var createdAt: GitLabAPI.Time { __data["createdAt"] }
						/// Timestamp of the note's last activity.
						public var updatedAt: GitLabAPI.Time { __data["updatedAt"] }

						/// Group.Epic.Notes.Node.Author
						///
						/// Parent Type: `UserCore`
						nonisolated public struct Author: GitLabAPI.SelectionSet {
							@_spi(Unsafe) public let __data: DataDict
							@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

							@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.UserCore }
							@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
								[
									.field("__typename", String.self),
									.field("avatarUrl", String?.self),
									.field("name", String.self),
									.field("username", String.self),
								]
							}
							@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
								[
									EpicQuery.Data.Group.Epic.Notes.Node.Author.self
								]
							}

							/// URL of the user's avatar.
							public var avatarUrl: String? { __data["avatarUrl"] }
							/// Human-readable name of the user. Returns `****` if the user is a project bot and the requester does not have permission to view the project.
							public var name: String { __data["name"] }
							/// Username of the user. Unique within the instance of GitLab.
							public var username: String { __data["username"] }
						}
					}
				}
			}
		}
	}
}
