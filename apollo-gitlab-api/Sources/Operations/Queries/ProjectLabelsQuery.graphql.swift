// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct ProjectLabelsQuery: GraphQLQuery {
	public static let operationName: String = "ProjectLabels"
	public static let operationDocument: ApolloAPI.OperationDocument = .init(
		definition: .init(
			#"query ProjectLabels($fullPath: ID!) { project(fullPath: $fullPath) { __typename labels { __typename nodes { __typename id title description color textColor } } } }"#
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
				.field("project", Project?.self, arguments: ["fullPath": .variable("fullPath")])
			]
		}
		@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
			[
				ProjectLabelsQuery.Data.self
			]
		}

		/// Find a project.
		public var project: Project? { __data["project"] }

		/// Project
		///
		/// Parent Type: `Project`
		nonisolated public struct Project: GitLabAPI.SelectionSet {
			@_spi(Unsafe) public let __data: DataDict
			@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

			@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Project }
			@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
				[
					.field("__typename", String.self),
					.field("labels", Labels?.self),
				]
			}
			@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
				[
					ProjectLabelsQuery.Data.Project.self
				]
			}

			/// Labels available on this project.
			public var labels: Labels? { __data["labels"] }

			/// Project.Labels
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
						ProjectLabelsQuery.Data.Project.Labels.self
					]
				}

				/// A list of nodes.
				public var nodes: [Node?]? { __data["nodes"] }

				/// Project.Labels.Node
				///
				/// Parent Type: `Label`
				nonisolated public struct Node: GitLabAPI.SelectionSet {
					@_spi(Unsafe) public let __data: DataDict
					@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

					@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Label }
					@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
						[
							.field("__typename", String.self),
							.field("id", GitLabAPI.LabelID.self),
							.field("title", String.self),
							.field("description", String?.self),
							.field("color", String.self),
							.field("textColor", String.self),
						]
					}
					@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
						[
							ProjectLabelsQuery.Data.Project.Labels.Node.self
						]
					}

					/// Global ID of the label.
					public var id: GitLabAPI.LabelID { __data["id"] }
					/// Content of the label.
					public var title: String { __data["title"] }
					/// Description of the label (Markdown rendered as HTML for caching).
					public var description: String? { __data["description"] }
					/// Background color of the label.
					public var color: String { __data["color"] }
					/// Text color of the label.
					public var textColor: String { __data["textColor"] }
				}
			}
		}
	}
}
