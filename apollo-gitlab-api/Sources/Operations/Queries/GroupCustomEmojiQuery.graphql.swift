// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct GroupCustomEmojiQuery: GraphQLQuery {
	public static let operationName: String = "GroupCustomEmoji"
	public static let operationDocument: ApolloAPI.OperationDocument = .init(
		definition: .init(
			#"query GroupCustomEmoji($fullPath: ID!) { group(fullPath: $fullPath) { __typename customEmoji { __typename nodes { __typename id url name createdAt } } } }"#
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
				GroupCustomEmojiQuery.Data.self
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
					.field("customEmoji", CustomEmoji?.self),
				]
			}
			@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
				[
					GroupCustomEmojiQuery.Data.Group.self
				]
			}

			/// Custom emoji in this namespace.
			public var customEmoji: CustomEmoji? { __data["customEmoji"] }

			/// Group.CustomEmoji
			///
			/// Parent Type: `CustomEmojiConnection`
			nonisolated public struct CustomEmoji: GitLabAPI.SelectionSet {
				@_spi(Unsafe) public let __data: DataDict
				@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

				@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.CustomEmojiConnection }
				@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
					[
						.field("__typename", String.self),
						.field("nodes", [Node?]?.self),
					]
				}
				@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
					[
						GroupCustomEmojiQuery.Data.Group.CustomEmoji.self
					]
				}

				/// A list of nodes.
				public var nodes: [Node?]? { __data["nodes"] }

				/// Group.CustomEmoji.Node
				///
				/// Parent Type: `CustomEmoji`
				nonisolated public struct Node: GitLabAPI.SelectionSet {
					@_spi(Unsafe) public let __data: DataDict
					@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

					@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.CustomEmoji }
					@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
						[
							.field("__typename", String.self),
							.field("id", GitLabAPI.CustomEmojiID.self),
							.field("url", String.self),
							.field("name", String.self),
							.field("createdAt", GitLabAPI.Time.self),
						]
					}
					@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
						[
							GroupCustomEmojiQuery.Data.Group.CustomEmoji.Node.self
						]
					}

					/// ID of the emoji.
					public var id: GitLabAPI.CustomEmojiID { __data["id"] }
					/// Link to file of the emoji.
					public var url: String { __data["url"] }
					/// Name of the emoji.
					public var name: String { __data["name"] }
					/// Timestamp of when the custom emoji was created.
					public var createdAt: GitLabAPI.Time { __data["createdAt"] }
				}
			}
		}
	}
}
