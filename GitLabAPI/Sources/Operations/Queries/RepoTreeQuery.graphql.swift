// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class RepoTreeQuery: GraphQLQuery {
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

  public var __variables: Variables? { [
    "fullPath": fullPath,
    "ref": ref,
    "path": path
  ] }

  public struct Data: GitLabAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("project", Project?.self, arguments: ["fullPath": .variable("fullPath")]),
    ] }

    /// Find a project.
    public var project: Project? { __data["project"] }

    /// Project
    ///
    /// Parent Type: `Project`
    public struct Project: GitLabAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Project }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("repository", Repository?.self),
      ] }

      /// Git repository of the project.
      public var repository: Repository? { __data["repository"] }

      /// Project.Repository
      ///
      /// Parent Type: `Repository`
      public struct Repository: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Repository }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("rootRef", String?.self),
          .field("tree", Tree?.self, arguments: [
            "ref": .variable("ref"),
            "path": .variable("path")
          ]),
        ] }

        /// Default branch of the repository.
        public var rootRef: String? { __data["rootRef"] }
        /// Tree of the repository.
        public var tree: Tree? { __data["tree"] }

        /// Project.Repository.Tree
        ///
        /// Parent Type: `Tree`
        public struct Tree: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Tree }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("blobs", Blobs.self),
            .field("trees", Trees.self),
          ] }

          /// Blobs of the tree.
          public var blobs: Blobs { __data["blobs"] }
          /// Trees of the tree.
          public var trees: Trees { __data["trees"] }

          /// Project.Repository.Tree.Blobs
          ///
          /// Parent Type: `BlobConnection`
          public struct Blobs: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.BlobConnection }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("nodes", [Node?]?.self),
            ] }

            /// A list of nodes.
            public var nodes: [Node?]? { __data["nodes"] }

            /// Project.Repository.Tree.Blobs.Node
            ///
            /// Parent Type: `Blob`
            public struct Node: GitLabAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Blob }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("name", String.self),
                .field("path", String.self),
              ] }

              /// Name of the entry.
              public var name: String { __data["name"] }
              /// Path of the entry.
              public var path: String { __data["path"] }
            }
          }

          /// Project.Repository.Tree.Trees
          ///
          /// Parent Type: `TreeEntryConnection`
          public struct Trees: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.TreeEntryConnection }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("nodes", [Node?]?.self),
            ] }

            /// A list of nodes.
            public var nodes: [Node?]? { __data["nodes"] }

            /// Project.Repository.Tree.Trees.Node
            ///
            /// Parent Type: `TreeEntry`
            public struct Node: GitLabAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.TreeEntry }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("name", String.self),
                .field("path", String.self),
              ] }

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
