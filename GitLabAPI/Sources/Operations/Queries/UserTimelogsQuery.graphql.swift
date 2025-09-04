// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

public struct UserTimelogsQuery: GraphQLQuery {
  public static let operationName: String = "UserTimelogs"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query UserTimelogs($username: String!) { user(username: $username) { __typename timelogs(sort: SPENT_AT_DESC) { __typename nodes { __typename id user { __typename avatarUrl name username } spentAt summary timeSpent project { __typename fullPath nameWithNamespace } issue { __typename iid } mergeRequest { __typename iid } } } } }"#
    ))

  public var username: String

  public init(username: String) {
    self.username = username
  }

  @_spi(Unsafe) public var __variables: Variables? { ["username": username] }

  public struct Data: GitLabAPI.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("user", User?.self, arguments: ["username": .variable("username")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      UserTimelogsQuery.Data.self
    ] }

    /// Find a user.
    public var user: User? { __data["user"] }

    /// User
    ///
    /// Parent Type: `UserCore`
    public struct User: GitLabAPI.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.UserCore }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("timelogs", Timelogs?.self, arguments: ["sort": "SPENT_AT_DESC"]),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        UserTimelogsQuery.Data.User.self
      ] }

      /// Time logged by the user.
      public var timelogs: Timelogs? { __data["timelogs"] }

      /// User.Timelogs
      ///
      /// Parent Type: `TimelogConnection`
      public struct Timelogs: GitLabAPI.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.TimelogConnection }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          UserTimelogsQuery.Data.User.Timelogs.self
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// User.Timelogs.Node
        ///
        /// Parent Type: `Timelog`
        public struct Node: GitLabAPI.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Timelog }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", GitLabAPI.ID.self),
            .field("user", User.self),
            .field("spentAt", GitLabAPI.Time?.self),
            .field("summary", String?.self),
            .field("timeSpent", Int.self),
            .field("project", Project.self),
            .field("issue", Issue?.self),
            .field("mergeRequest", MergeRequest?.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            UserTimelogsQuery.Data.User.Timelogs.Node.self
          ] }

          /// Internal ID of the timelog.
          public var id: GitLabAPI.ID { __data["id"] }
          /// User that logged the time.
          public var user: User { __data["user"] }
          /// Timestamp of when the time tracked was spent at.
          public var spentAt: GitLabAPI.Time? { __data["spentAt"] }
          /// Summary of how the time was spent.
          public var summary: String? { __data["summary"] }
          /// Time spent displayed in seconds.
          public var timeSpent: Int { __data["timeSpent"] }
          /// Target project of the timelog merge request or issue.
          public var project: Project { __data["project"] }
          /// Issue that logged time was added to.
          public var issue: Issue? { __data["issue"] }
          /// Merge request that logged time was added to.
          public var mergeRequest: MergeRequest? { __data["mergeRequest"] }

          /// User.Timelogs.Node.User
          ///
          /// Parent Type: `UserCore`
          public struct User: GitLabAPI.SelectionSet {
            @_spi(Unsafe) public let __data: DataDict
            @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

            @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.UserCore }
            @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("avatarUrl", String?.self),
              .field("name", String.self),
              .field("username", String.self),
            ] }
            @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              UserTimelogsQuery.Data.User.Timelogs.Node.User.self
            ] }

            /// URL of the user's avatar.
            public var avatarUrl: String? { __data["avatarUrl"] }
            /// Human-readable name of the user. Returns `****` if the user is a project bot and the requester does not have permission to view the project.
            public var name: String { __data["name"] }
            /// Username of the user. Unique within the instance of GitLab.
            public var username: String { __data["username"] }
          }

          /// User.Timelogs.Node.Project
          ///
          /// Parent Type: `Project`
          public struct Project: GitLabAPI.SelectionSet {
            @_spi(Unsafe) public let __data: DataDict
            @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

            @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Project }
            @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("fullPath", GitLabAPI.ID.self),
              .field("nameWithNamespace", String.self),
            ] }
            @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              UserTimelogsQuery.Data.User.Timelogs.Node.Project.self
            ] }

            /// Full path of the project.
            public var fullPath: GitLabAPI.ID { __data["fullPath"] }
            /// Name of the project including the namespace.
            public var nameWithNamespace: String { __data["nameWithNamespace"] }
          }

          /// User.Timelogs.Node.Issue
          ///
          /// Parent Type: `Issue`
          public struct Issue: GitLabAPI.SelectionSet {
            @_spi(Unsafe) public let __data: DataDict
            @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

            @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Issue }
            @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("iid", String.self),
            ] }
            @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              UserTimelogsQuery.Data.User.Timelogs.Node.Issue.self
            ] }

            /// Internal ID of the issue.
            public var iid: String { __data["iid"] }
          }

          /// User.Timelogs.Node.MergeRequest
          ///
          /// Parent Type: `MergeRequest`
          public struct MergeRequest: GitLabAPI.SelectionSet {
            @_spi(Unsafe) public let __data: DataDict
            @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

            @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.MergeRequest }
            @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("iid", String.self),
            ] }
            @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              UserTimelogsQuery.Data.User.Timelogs.Node.MergeRequest.self
            ] }

            /// Internal ID of the merge request.
            public var iid: String { __data["iid"] }
          }
        }
      }
    }
  }
}
