// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct CurrentUserSnippetsQuery: GraphQLQuery {
	public static let operationName: String = "CurrentUserSnippets"
	public static let operationDocument: ApolloAPI.OperationDocument = .init(
		definition: .init(
			#"query CurrentUserSnippets { currentUser { __typename snippets { __typename nodes { __typename id title visibilityLevel author { __typename avatarUrl name username } createdAt webUrl } } } }"#
		))

	public init() {}

	nonisolated public struct Data: GitLabAPI.SelectionSet {
		@_spi(Unsafe) public let __data: DataDict
		@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

		@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Query }
		@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
			[
				.field("currentUser", CurrentUser?.self)
			]
		}
		@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
			[
				CurrentUserSnippetsQuery.Data.self
			]
		}

		/// Get information about current user.
		public var currentUser: CurrentUser? { __data["currentUser"] }

		/// CurrentUser
		///
		/// Parent Type: `CurrentUser`
		nonisolated public struct CurrentUser: GitLabAPI.SelectionSet {
			@_spi(Unsafe) public let __data: DataDict
			@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

			@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.CurrentUser }
			@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
				[
					.field("__typename", String.self),
					.field("snippets", Snippets?.self),
				]
			}
			@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
				[
					CurrentUserSnippetsQuery.Data.CurrentUser.self
				]
			}

			/// Snippets authored by the user.
			public var snippets: Snippets? { __data["snippets"] }

			/// CurrentUser.Snippets
			///
			/// Parent Type: `SnippetConnection`
			nonisolated public struct Snippets: GitLabAPI.SelectionSet {
				@_spi(Unsafe) public let __data: DataDict
				@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

				@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.SnippetConnection }
				@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
					[
						.field("__typename", String.self),
						.field("nodes", [Node?]?.self),
					]
				}
				@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
					[
						CurrentUserSnippetsQuery.Data.CurrentUser.Snippets.self
					]
				}

				/// A list of nodes.
				public var nodes: [Node?]? { __data["nodes"] }

				/// CurrentUser.Snippets.Node
				///
				/// Parent Type: `Snippet`
				nonisolated public struct Node: GitLabAPI.SelectionSet {
					@_spi(Unsafe) public let __data: DataDict
					@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

					@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Snippet }
					@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
						[
							.field("__typename", String.self),
							.field("id", GitLabAPI.SnippetID.self),
							.field("title", String.self),
							.field("visibilityLevel", GraphQLEnum<GitLabAPI.VisibilityLevelsEnum>.self),
							.field("author", Author?.self),
							.field("createdAt", GitLabAPI.Time.self),
							.field("webUrl", String.self),
						]
					}
					@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
						[
							CurrentUserSnippetsQuery.Data.CurrentUser.Snippets.Node.self
						]
					}

					/// ID of the snippet.
					public var id: GitLabAPI.SnippetID { __data["id"] }
					/// Title of the snippet.
					public var title: String { __data["title"] }
					/// Visibility Level of the snippet.
					public var visibilityLevel: GraphQLEnum<GitLabAPI.VisibilityLevelsEnum> { __data["visibilityLevel"] }
					/// Owner of the snippet.
					public var author: Author? { __data["author"] }
					/// Timestamp the snippet was created.
					public var createdAt: GitLabAPI.Time { __data["createdAt"] }
					/// Web URL of the snippet.
					public var webUrl: String { __data["webUrl"] }

					/// CurrentUser.Snippets.Node.Author
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
								CurrentUserSnippetsQuery.Data.CurrentUser.Snippets.Node.Author.self
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
