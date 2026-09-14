// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct RepoTreeQuery: GraphQLQuery {
	public static let operationName: String = "RepoTree"
	public static let operationDocument: ApolloAPI.OperationDocument = .init(
		definition: .init(
			#"query RepoTree($fullPath: ID!, $ref: String, $path: String) { project(fullPath: $fullPath) { __typename repository { __typename rootRef tree(ref: $ref, path: $path) { __typename blobs { __typename nodes { __typename name path } } trees { __typename nodes { __typename name path } } } } } }"#
		))

	public var fullPath: ID
	public var ref: GraphQLNullable<String>
	public var path: GraphQLNullable<String>

	public init(
		fullPath: ID,
		ref: GraphQLNullable<String>,
		path: GraphQLNullable<String>
	) {
		self.fullPath = fullPath
		self.ref = ref
		self.path = path
	}

	@_spi(Unsafe) public var __variables: Variables? {
		[
			"fullPath": fullPath,
			"ref": ref,
			"path": path,
		]
	}

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
				RepoTreeQuery.Data.self
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
					.field("repository", Repository?.self),
				]
			}
			@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
				[
					RepoTreeQuery.Data.Project.self
				]
			}

			/// Git repository of the project.
			public var repository: Repository? { __data["repository"] }

			/// Project.Repository
			///
			/// Parent Type: `Repository`
			nonisolated public struct Repository: GitLabAPI.SelectionSet {
				@_spi(Unsafe) public let __data: DataDict
				@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

				@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Repository }
				@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
					[
						.field("__typename", String.self),
						.field("rootRef", String?.self),
						.field(
							"tree", Tree?.self,
							arguments: [
								"ref": .variable("ref"),
								"path": .variable("path"),
							]),
					]
				}
				@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
					[
						RepoTreeQuery.Data.Project.Repository.self
					]
				}

				/// Default branch of the repository.
				public var rootRef: String? { __data["rootRef"] }
				/// Tree of the repository.
				public var tree: Tree? { __data["tree"] }

				/// Project.Repository.Tree
				///
				/// Parent Type: `Tree`
				nonisolated public struct Tree: GitLabAPI.SelectionSet {
					@_spi(Unsafe) public let __data: DataDict
					@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

					@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Tree }
					@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
						[
							.field("__typename", String.self),
							.field("blobs", Blobs.self),
							.field("trees", Trees.self),
						]
					}
					@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
						[
							RepoTreeQuery.Data.Project.Repository.Tree.self
						]
					}

					/// Blobs of the tree.
					public var blobs: Blobs { __data["blobs"] }
					/// Trees of the tree.
					public var trees: Trees { __data["trees"] }

					/// Project.Repository.Tree.Blobs
					///
					/// Parent Type: `BlobConnection`
					nonisolated public struct Blobs: GitLabAPI.SelectionSet {
						@_spi(Unsafe) public let __data: DataDict
						@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

						@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.BlobConnection }
						@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
							[
								.field("__typename", String.self),
								.field("nodes", [Node?]?.self),
							]
						}
						@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
							[
								RepoTreeQuery.Data.Project.Repository.Tree.Blobs.self
							]
						}

						/// A list of nodes.
						public var nodes: [Node?]? { __data["nodes"] }

						/// Project.Repository.Tree.Blobs.Node
						///
						/// Parent Type: `Blob`
						nonisolated public struct Node: GitLabAPI.SelectionSet {
							@_spi(Unsafe) public let __data: DataDict
							@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

							@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Blob }
							@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
								[
									.field("__typename", String.self),
									.field("name", String.self),
									.field("path", String.self),
								]
							}
							@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
								[
									RepoTreeQuery.Data.Project.Repository.Tree.Blobs.Node.self
								]
							}

							/// Name of the entry.
							public var name: String { __data["name"] }
							/// Path of the entry.
							public var path: String { __data["path"] }
						}
					}

					/// Project.Repository.Tree.Trees
					///
					/// Parent Type: `TreeEntryConnection`
					nonisolated public struct Trees: GitLabAPI.SelectionSet {
						@_spi(Unsafe) public let __data: DataDict
						@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

						@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.TreeEntryConnection }
						@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
							[
								.field("__typename", String.self),
								.field("nodes", [Node?]?.self),
							]
						}
						@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
							[
								RepoTreeQuery.Data.Project.Repository.Tree.Trees.self
							]
						}

						/// A list of nodes.
						public var nodes: [Node?]? { __data["nodes"] }

						/// Project.Repository.Tree.Trees.Node
						///
						/// Parent Type: `TreeEntry`
						nonisolated public struct Node: GitLabAPI.SelectionSet {
							@_spi(Unsafe) public let __data: DataDict
							@_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

							@_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.TreeEntry }
							@_spi(Execution) public static var __selections: [ApolloAPI.Selection] {
								[
									.field("__typename", String.self),
									.field("name", String.self),
									.field("path", String.self),
								]
							}
							@_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] {
								[
									RepoTreeQuery.Data.Project.Repository.Tree.Trees.Node.self
								]
							}

							/// Name of the entry.
							public var name: String { __data["name"] }
							/// Path of the entry.
							public var path: String { __data["path"] }
						}
					}
				}
			}
		}
	}
}
