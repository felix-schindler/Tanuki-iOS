// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct MergeRequestCommitsQuery: GraphQLQuery {
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

  @_spi(Unsafe) public var __variables: Variables? { [
    "fullPath": fullPath,
    "iid": iid
  ] }

  nonisolated public struct Data: IOSGitLabAPI.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("project", Project?.self, arguments: ["fullPath": .variable("fullPath")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      MergeRequestCommitsQuery.Data.self
    ] }

    /// Find a project.
    public var project: Project? { __data["project"] }

    /// Project
    ///
    /// Parent Type: `Project`
    nonisolated public struct Project: IOSGitLabAPI.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.Project }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", IOSGitLabAPI.ID.self),
        .field("mergeRequest", MergeRequest?.self, arguments: ["iid": .variable("iid")]),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        MergeRequestCommitsQuery.Data.Project.self
      ] }

      /// ID of the project.
      public var id: IOSGitLabAPI.ID { __data["id"] }
      /// A single merge request of the project.
      public var mergeRequest: MergeRequest? { __data["mergeRequest"] }

      /// Project.MergeRequest
      ///
      /// Parent Type: `MergeRequest`
      nonisolated public struct MergeRequest: IOSGitLabAPI.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.MergeRequest }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("commits", Commits?.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          MergeRequestCommitsQuery.Data.Project.MergeRequest.self
        ] }

        /// Merge request commits.
        public var commits: Commits? { __data["commits"] }

        /// Project.MergeRequest.Commits
        ///
        /// Parent Type: `CommitConnection`
        nonisolated public struct Commits: IOSGitLabAPI.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.CommitConnection }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("nodes", [Node?]?.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            MergeRequestCommitsQuery.Data.Project.MergeRequest.Commits.self
          ] }

          /// A list of nodes.
          public var nodes: [Node?]? { __data["nodes"] }

          /// Project.MergeRequest.Commits.Node
          ///
          /// Parent Type: `Commit`
          nonisolated public struct Node: IOSGitLabAPI.SelectionSet {
            @_spi(Unsafe) public let __data: DataDict
            @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

            @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.Commit }
            @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", IOSGitLabAPI.ID.self),
              .field("title", String?.self),
              .field("shortId", String.self),
              .field("authorName", String?.self),
              .field("authoredDate", IOSGitLabAPI.Time?.self),
              .field("webUrl", String.self),
              .field("signature", Signature?.self),
              .field("pipelines", Pipelines?.self),
            ] }
            @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              MergeRequestCommitsQuery.Data.Project.MergeRequest.Commits.Node.self
            ] }

            /// ID (global ID) of the commit.
            public var id: IOSGitLabAPI.ID { __data["id"] }
            /// Title of the commit message.
            public var title: String? { __data["title"] }
            /// Short SHA1 ID of the commit.
            public var shortId: String { __data["shortId"] }
            /// Commit authors name.
            public var authorName: String? { __data["authorName"] }
            /// Timestamp of when the commit was authored.
            public var authoredDate: IOSGitLabAPI.Time? { __data["authoredDate"] }
            /// Web URL of the commit.
            public var webUrl: String { __data["webUrl"] }
            /// Signature of the commit.
            public var signature: Signature? { __data["signature"] }
            /// Pipelines of the commit ordered latest first.
            public var pipelines: Pipelines? { __data["pipelines"] }

            /// Project.MergeRequest.Commits.Node.Signature
            ///
            /// Parent Type: `CommitSignature`
            nonisolated public struct Signature: IOSGitLabAPI.SelectionSet {
              @_spi(Unsafe) public let __data: DataDict
              @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

              @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Interfaces.CommitSignature }
              @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("verificationStatus", GraphQLEnum<IOSGitLabAPI.VerificationStatus>?.self),
              ] }
              @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                MergeRequestCommitsQuery.Data.Project.MergeRequest.Commits.Node.Signature.self
              ] }

              /// Indicates verification status of the associated key or certificate.
              public var verificationStatus: GraphQLEnum<IOSGitLabAPI.VerificationStatus>? { __data["verificationStatus"] }
            }

            /// Project.MergeRequest.Commits.Node.Pipelines
            ///
            /// Parent Type: `PipelineConnection`
            nonisolated public struct Pipelines: IOSGitLabAPI.SelectionSet {
              @_spi(Unsafe) public let __data: DataDict
              @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

              @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.PipelineConnection }
              @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("nodes", [Node?]?.self),
              ] }
              @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                MergeRequestCommitsQuery.Data.Project.MergeRequest.Commits.Node.Pipelines.self
              ] }

              /// A list of nodes.
              public var nodes: [Node?]? { __data["nodes"] }

              /// Project.MergeRequest.Commits.Node.Pipelines.Node
              ///
              /// Parent Type: `Pipeline`
              nonisolated public struct Node: IOSGitLabAPI.SelectionSet {
                @_spi(Unsafe) public let __data: DataDict
                @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

                @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.Pipeline }
                @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("status", GraphQLEnum<IOSGitLabAPI.PipelineStatusEnum>.self),
                ] }
                @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                  MergeRequestCommitsQuery.Data.Project.MergeRequest.Commits.Node.Pipelines.Node.self
                ] }

                /// Status of the pipeline (CREATED, WAITING_FOR_RESOURCE, PREPARING, WAITING_FOR_CALLBACK, PENDING, RUNNING, FAILED, SUCCESS, CANCELED, CANCELING, SKIPPED, MANUAL, SCHEDULED)
                public var status: GraphQLEnum<IOSGitLabAPI.PipelineStatusEnum> { __data["status"] }
              }
            }
          }
        }
      }
    }
  }
}
