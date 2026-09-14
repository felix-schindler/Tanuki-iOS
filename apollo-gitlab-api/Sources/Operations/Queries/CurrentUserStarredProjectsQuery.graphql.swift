// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct CurrentUserStarredProjectsQuery: GraphQLQuery {
	public static let operationName: String = "CurrentUserStarredProjects"
	public static let operationDocument: ApolloAPI.OperationDocument = .init(
		definition: .init(
			#"query CurrentUserStarredProjects { currentUser { __typename starredProjects { __typename nodes { __typename avatarUrl nameWithNamespace visibility fullPath } } } }"#
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
				CurrentUserStarredProjectsQuery.Data.self
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
					.field("starredProjects", StarredProjects?.self),
				]
			}
			@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
				[
					CurrentUserStarredProjectsQuery.Data.CurrentUser.self
				]
			}

			/// Projects starred by the user.
			public var starredProjects: StarredProjects? { __data["starredProjects"] }

			/// CurrentUser.StarredProjects
			///
			/// Parent Type: `ProjectConnection`
			nonisolated public struct StarredProjects: GitLabAPI.SelectionSet {
				@_spi(Unsafe) public let __data: DataDict
				@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

				@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.ProjectConnection }
				@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
					[
						.field("__typename", String.self),
						.field("nodes", [Node?]?.self),
					]
				}
				@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
					[
						CurrentUserStarredProjectsQuery.Data.CurrentUser.StarredProjects.self
					]
				}

				/// A list of nodes.
				public var nodes: [Node?]? { __data["nodes"] }

				/// CurrentUser.StarredProjects.Node
				///
				/// Parent Type: `Project`
				nonisolated public struct Node: GitLabAPI.SelectionSet {
					@_spi(Unsafe) public let __data: DataDict
					@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

					@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Project }
					@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
						[
							.field("__typename", String.self),
							.field("avatarUrl", String?.self),
							.field("nameWithNamespace", String.self),
							.field("visibility", String?.self),
							.field("fullPath", GitLabAPI.ID.self),
						]
					}
					@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
						[
							CurrentUserStarredProjectsQuery.Data.CurrentUser.StarredProjects.Node.self
						]
					}

					/// Avatar URL of the project.
					public var avatarUrl: String? { __data["avatarUrl"] }
					/// Name of the project including the namespace.
					public var nameWithNamespace: String { __data["nameWithNamespace"] }
					/// Visibility of the project.
					public var visibility: String? { __data["visibility"] }
					/// Full path of the project.
					public var fullPath: GitLabAPI.ID { __data["fullPath"] }
				}
			}
		}
	}
}
