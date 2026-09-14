// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct UsersQuery: GraphQLQuery {
	public static let operationName: String = "Users"
	public static let operationDocument: ApolloAPI.OperationDocument = .init(
		definition: .init(
			#"query Users($search: String, $admins: Boolean, $active: Boolean, $humans: Boolean) { users(search: $search, admins: $admins, active: $active, humans: $humans) { __typename nodes { __typename avatarUrl name username } } }"#
		))

	public var search: GraphQLNullable<String>
	public var admins: GraphQLNullable<Bool>
	public var active: GraphQLNullable<Bool>
	public var humans: GraphQLNullable<Bool>

	public init(
		search: GraphQLNullable<String>,
		admins: GraphQLNullable<Bool>,
		active: GraphQLNullable<Bool>,
		humans: GraphQLNullable<Bool>
	) {
		self.search = search
		self.admins = admins
		self.active = active
		self.humans = humans
	}

	@_spi(Unsafe) public var __variables: Variables? {
		[
			"search": search,
			"admins": admins,
			"active": active,
			"humans": humans,
		]
	}

	nonisolated public struct Data: GitLabAPI.SelectionSet {
		@_spi(Unsafe) public let __data: DataDict
		@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

		@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Query }
		@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
			[
				.field(
					"users", Users?.self,
					arguments: [
						"search": .variable("search"),
						"admins": .variable("admins"),
						"active": .variable("active"),
						"humans": .variable("humans"),
					])
			]
		}
		@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
			[
				UsersQuery.Data.self
			]
		}

		/// Find users.
		public var users: Users? { __data["users"] }

		/// Users
		///
		/// Parent Type: `UserCoreConnection`
		nonisolated public struct Users: GitLabAPI.SelectionSet {
			@_spi(Unsafe) public let __data: DataDict
			@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

			@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.UserCoreConnection }
			@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
				[
					.field("__typename", String.self),
					.field("nodes", [Node?]?.self),
				]
			}
			@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
				[
					UsersQuery.Data.Users.self
				]
			}

			/// A list of nodes.
			public var nodes: [Node?]? { __data["nodes"] }

			/// Users.Node
			///
			/// Parent Type: `UserCore`
			nonisolated public struct Node: GitLabAPI.SelectionSet {
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
						UsersQuery.Data.Users.Node.self
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
