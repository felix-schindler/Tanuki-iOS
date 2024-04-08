// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class MergeRequestCommitsQuery: GraphQLQuery {
  public static let operationName: String = "MergeRequestCommits"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query MergeRequestCommits($fullPath: ID!, $iid: String!) { project(fullPath: $fullPath) { __typename id mergeRequest(iid: $iid) { __typename commits { __typename nodes { __typename id title shortId authorName authoredDate webUrl signature { __typename verificationStatus } pipelines { __typename nodes { __typename status } } } } } } }"#
    ))

  public var fullPath: ID
  public var iid: String

  public init(
    fullPath: ID,
    iid: String
  ) {
    self.fullPath = fullPath
    self.iid = iid
  }

  public var __variables: Variables? { [
    "fullPath": fullPath,
    "iid": iid
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
        .field("id", GitLabAPI.ID.self),
        .field("mergeRequest", MergeRequest?.self, arguments: ["iid": .variable("iid")]),
      ] }

      /// ID of the project.
      public var id: GitLabAPI.ID { __data["id"] }
      /// A single merge request of the project.
      public var mergeRequest: MergeRequest? { __data["mergeRequest"] }

      /// Project.MergeRequest
      ///
      /// Parent Type: `MergeRequest`
      public struct MergeRequest: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.MergeRequest }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("commits", Commits?.self),
        ] }

        /// Merge request commits.
        public var commits: Commits? { __data["commits"] }

        /// Project.MergeRequest.Commits
        ///
        /// Parent Type: `CommitConnection`
        public struct Commits: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.CommitConnection }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("nodes", [Node?]?.self),
          ] }

          /// A list of nodes.
          public var nodes: [Node?]? { __data["nodes"] }

          /// Project.MergeRequest.Commits.Node
          ///
          /// Parent Type: `Commit`
          public struct Node: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Commit }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", GitLabAPI.ID.self),
              .field("title", String?.self),
              .field("shortId", String.self),
              .field("authorName", String?.self),
              .field("authoredDate", GitLabAPI.Time?.self),
              .field("webUrl", String.self),
              .field("signature", Signature?.self),
              .field("pipelines", Pipelines?.self),
            ] }

            /// ID (global ID) of the commit.
            public var id: GitLabAPI.ID { __data["id"] }
            /// Title of the commit message.
            public var title: String? { __data["title"] }
            /// Short SHA1 ID of the commit.
            public var shortId: String { __data["shortId"] }
            /// Commit authors name.
            public var authorName: String? { __data["authorName"] }
            /// Timestamp of when the commit was authored.
            public var authoredDate: GitLabAPI.Time? { __data["authoredDate"] }
            /// Web URL of the commit.
            public var webUrl: String { __data["webUrl"] }
            /// Signature of the commit.
            public var signature: Signature? { __data["signature"] }
            /// Pipelines of the commit ordered latest first.
            public var pipelines: Pipelines? { __data["pipelines"] }

            /// Project.MergeRequest.Commits.Node.Signature
            ///
            /// Parent Type: `CommitSignature`
            public struct Signature: GitLabAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Interfaces.CommitSignature }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("verificationStatus", GraphQLEnum<GitLabAPI.VerificationStatus>?.self),
              ] }

              /// Indicates verification status of the associated key or certificate.
              public var verificationStatus: GraphQLEnum<GitLabAPI.VerificationStatus>? { __data["verificationStatus"] }
            }

            /// Project.MergeRequest.Commits.Node.Pipelines
            ///
            /// Parent Type: `PipelineConnection`
            public struct Pipelines: GitLabAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.PipelineConnection }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("nodes", [Node?]?.self),
              ] }

              /// A list of nodes.
              public var nodes: [Node?]? { __data["nodes"] }

              /// Project.MergeRequest.Commits.Node.Pipelines.Node
              ///
              /// Parent Type: `Pipeline`
              public struct Node: GitLabAPI.SelectionSet {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Pipeline }
                public static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("status", GraphQLEnum<GitLabAPI.PipelineStatusEnum>.self),
                ] }

                /// Status of the pipeline (CREATED, WAITING_FOR_RESOURCE, PREPARING, WAITING_FOR_CALLBACK, PENDING, RUNNING, FAILED, SUCCESS, CANCELED, SKIPPED, MANUAL, SCHEDULED)
                public var status: GraphQLEnum<GitLabAPI.PipelineStatusEnum> { __data["status"] }
              }
            }
          }
        }
      }
    }
  }
}
