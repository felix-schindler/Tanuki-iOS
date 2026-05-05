// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct IssueStateMutation: GraphQLMutation {
  public static let operationName: String = "IssueState"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation IssueState($projectPath: ID!, $iid: String!, $stateEvent: IssueStateEvent) { updateIssue( input: { projectPath: $projectPath, iid: $iid, stateEvent: $stateEvent } ) { __typename issue { __typename id iid title state webUrl } errors } }"#
    ))

  public var projectPath: ID
  public var iid: String
  public var stateEvent: GraphQLNullable<GraphQLEnum<IssueStateEvent>>

  public init(
    projectPath: ID,
    iid: String,
    stateEvent: GraphQLNullable<GraphQLEnum<IssueStateEvent>>
  ) {
    self.projectPath = projectPath
    self.iid = iid
    self.stateEvent = stateEvent
  }

  @_spi(Unsafe) public var __variables: Variables? { [
    "projectPath": projectPath,
    "iid": iid,
    "stateEvent": stateEvent
  ] }

  nonisolated public struct Data: IOSGitLabAPI.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.Mutation }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("updateIssue", UpdateIssue?.self, arguments: ["input": [
        "projectPath": .variable("projectPath"),
        "iid": .variable("iid"),
        "stateEvent": .variable("stateEvent")
      ]]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      IssueStateMutation.Data.self
    ] }

    public var updateIssue: UpdateIssue? { __data["updateIssue"] }

    /// UpdateIssue
    ///
    /// Parent Type: `UpdateIssuePayload`
    nonisolated public struct UpdateIssue: IOSGitLabAPI.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.UpdateIssuePayload }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("issue", Issue?.self),
        .field("errors", [String].self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        IssueStateMutation.Data.UpdateIssue.self
      ] }

      /// Issue after mutation.
      public var issue: Issue? { __data["issue"] }
      /// Errors encountered during the mutation.
      public var errors: [String] { __data["errors"] }

      /// UpdateIssue.Issue
      ///
      /// Parent Type: `Issue`
      nonisolated public struct Issue: IOSGitLabAPI.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { IOSGitLabAPI.Objects.Issue }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", IOSGitLabAPI.ID.self),
          .field("iid", String.self),
          .field("title", String.self),
          .field("state", GraphQLEnum<IOSGitLabAPI.IssueState>.self),
          .field("webUrl", String.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          IssueStateMutation.Data.UpdateIssue.Issue.self
        ] }

        /// ID of the issue.
        public var id: IOSGitLabAPI.ID { __data["id"] }
        /// Internal ID of the issue.
        public var iid: String { __data["iid"] }
        /// Title of the issue.
        public var title: String { __data["title"] }
        /// State of the issue.
        public var state: GraphQLEnum<IOSGitLabAPI.IssueState> { __data["state"] }
        /// Web URL of the issue.
        public var webUrl: String { __data["webUrl"] }
      }
    }
  }
}
