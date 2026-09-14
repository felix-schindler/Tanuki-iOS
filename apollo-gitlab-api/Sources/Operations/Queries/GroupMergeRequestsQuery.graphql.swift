// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct GroupMergeRequestsQuery: GraphQLQuery {
	public static let operationName: String = "GroupMergeRequests"
	public static let operationDocument: ApolloAPI.OperationDocument = .init(
		definition: .init(
			#"query GroupMergeRequests($fullPath: ID!) { group(fullPath: $fullPath) { __typename mergeRequests(state: opened) { __typename nodes { __typename iid title reference(full: true) state upvotes downvotes userNotesCount author { __typename avatarUrl name username } createdAt webUrl } } } }"#
		))

	public var fullPath: ID

	public init(fullPath: ID) {
		self.fullPath = fullPath
	}

	@_spi(Unsafe) public var __variables: Variables? { ["fullPath": fullPath] }

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
				GroupMergeRequestsQuery.Data.self
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
					.field("mergeRequests", MergeRequests?.self, arguments: ["state": "opened"]),
				]
			}
			@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
				[
					GroupMergeRequestsQuery.Data.Group.self
				]
			}

			/// Merge requests for projects in this group.
			public var mergeRequests: MergeRequests? { __data["mergeRequests"] }

			/// Group.MergeRequests
			///
			/// Parent Type: `MergeRequestConnection`
			nonisolated public struct MergeRequests: GitLabAPI.SelectionSet {
				@_spi(Unsafe) public let __data: DataDict
				@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

				@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.MergeRequestConnection }
				@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
					[
						.field("__typename", String.self),
						.field("nodes", [Node?]?.self),
					]
				}
				@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
					[
						GroupMergeRequestsQuery.Data.Group.MergeRequests.self
					]
				}

				/// A list of nodes.
				public var nodes: [Node?]? { __data["nodes"] }

				/// Group.MergeRequests.Node
				///
				/// Parent Type: `MergeRequest`
				nonisolated public struct Node: GitLabAPI.SelectionSet {
					@_spi(Unsafe) public let __data: DataDict
					@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

					@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.MergeRequest }
					@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
						[
							.field("__typename", String.self),
							.field("iid", String.self),
							.field("title", String.self),
							.field("reference", String.self, arguments: ["full": true]),
							.field("state", GraphQLEnum<GitLabAPI.MergeRequestState>.self),
							.field("upvotes", Int.self),
							.field("downvotes", Int.self),
							.field("userNotesCount", Int?.self),
							.field("author", Author?.self),
							.field("createdAt", GitLabAPI.Time.self),
							.field("webUrl", String?.self),
						]
					}
					@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
						[
							GroupMergeRequestsQuery.Data.Group.MergeRequests.Node.self
						]
					}

					/// Internal ID of the merge request.
					public var iid: String { __data["iid"] }
					/// Title of the merge request.
					public var title: String { __data["title"] }
					/// Internal reference of the merge request. Returned in shortened format by default.
					public var reference: String { __data["reference"] }
					/// State of the merge request.
					public var state: GraphQLEnum<GitLabAPI.MergeRequestState> { __data["state"] }
					/// Number of upvotes for the merge request.
					public var upvotes: Int { __data["upvotes"] }
					/// Number of downvotes for the merge request.
					public var downvotes: Int { __data["downvotes"] }
					/// User notes count of the merge request.
					public var userNotesCount: Int? { __data["userNotesCount"] }
					/// User who created the merge request.
					public var author: Author? { __data["author"] }
					/// Timestamp of when the merge request was created.
					public var createdAt: GitLabAPI.Time { __data["createdAt"] }
					/// Web URL of the merge request.
					public var webUrl: String? { __data["webUrl"] }

					/// Group.MergeRequests.Node.Author
					///
					/// Parent Type: `MergeRequestAuthor`
					nonisolated public struct Author: GitLabAPI.SelectionSet {
						@_spi(Unsafe) public let __data: DataDict
						@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

						@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.MergeRequestAuthor }
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
								GroupMergeRequestsQuery.Data.Group.MergeRequests.Node.Author.self
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
