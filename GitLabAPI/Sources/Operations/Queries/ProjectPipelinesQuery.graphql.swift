// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class ProjectPipelinesQuery: GraphQLQuery {
  public static let operationName: String = "ProjectPipelines"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query ProjectPipelines($fullPath: ID!) { project(fullPath: $fullPath) { __typename pipelines { __typename nodes { __typename id iid user { __typename avatarUrl name username } ref commit { __typename shortId } source status cancelable createdAt } } } }"#
    ))

  public var fullPath: ID

  public init(fullPath: ID) {
    self.fullPath = fullPath
  }

  public var __variables: Variables? { ["fullPath": fullPath] }

  public struct Data: GitLabAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Query }
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

      public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Project }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("pipelines", Pipelines?.self),
      ] }

      /// Pipelines of the project.
      public var pipelines: Pipelines? { __data["pipelines"] }

      /// Project.Pipelines
      ///
      /// Parent Type: `PipelineConnection`
      public struct Pipelines: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.PipelineConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Project.Pipelines.Node
        ///
        /// Parent Type: `Pipeline`
        public struct Node: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Pipeline }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", GitLabAPI.ID.self),
            .field("iid", String.self),
            .field("user", User?.self),
            .field("ref", String?.self),
            .field("commit", Commit?.self),
            .field("source", String?.self),
            .field("status", GraphQLEnum<GitLabAPI.PipelineStatusEnum>.self),
            .field("cancelable", Bool.self),
            .field("createdAt", GitLabAPI.Time.self),
          ] }

          /// ID of the pipeline.
          public var id: GitLabAPI.ID { __data["id"] }
          /// Internal ID of the pipeline.
          public var iid: String { __data["iid"] }
          /// Pipeline user.
          public var user: User? { __data["user"] }
          /// Reference to the branch from which the pipeline was triggered.
          public var ref: String? { __data["ref"] }
          /// Git commit of the pipeline.
          public var commit: Commit? { __data["commit"] }
          /// Source of the pipeline.
          public var source: String? { __data["source"] }
          /// Status of the pipeline (CREATED, WAITING_FOR_RESOURCE, PREPARING, WAITING_FOR_CALLBACK, PENDING, RUNNING, FAILED, SUCCESS, CANCELED, CANCELING, SKIPPED, MANUAL, SCHEDULED)
          public var status: GraphQLEnum<GitLabAPI.PipelineStatusEnum> { __data["status"] }
          /// Specifies if a pipeline can be canceled.
          public var cancelable: Bool { __data["cancelable"] }
          /// Timestamp of the pipeline's creation.
          public var createdAt: GitLabAPI.Time { __data["createdAt"] }

          /// Project.Pipelines.Node.User
          ///
          /// Parent Type: `UserCore`
          public struct User: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.UserCore }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("avatarUrl", String?.self),
              .field("name", String.self),
              .field("username", String.self),
            ] }

            /// URL of the user's avatar.
            public var avatarUrl: String? { __data["avatarUrl"] }
            /// Human-readable name of the user. Returns `****` if the user is a project bot and the requester does not have permission to view the project.
            public var name: String { __data["name"] }
            /// Username of the user. Unique within the instance of GitLab.
            public var username: String { __data["username"] }
          }

          /// Project.Pipelines.Node.Commit
          ///
          /// Parent Type: `Commit`
          public struct Commit: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Commit }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("shortId", String.self),
            ] }

            /// Short SHA1 ID of the commit.
            public var shortId: String { __data["shortId"] }
          }
        }
      }
    }
  }
}
