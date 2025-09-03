// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class UserTimelogsQuery: GraphQLQuery {
  public static let operationName: String = "UserTimelogs"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query UserTimelogs($username: String!) { user(username: $username) { __typename timelogs(sort: SPENT_AT_DESC) { __typename nodes { __typename id user { __typename avatarUrl name username } spentAt summary timeSpent project { __typename fullPath nameWithNamespace } issue { __typename iid } mergeRequest { __typename iid } } } } }"#
    ))

  public var username: String

  public init(username: String) {
    self.username = username
  }

  public var __variables: Variables? { ["username": username] }

  public struct Data: GitLabAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("user", User?.self, arguments: ["username": .variable("username")]),
    ] }

    /// Find a user.
    public var user: User? { __data["user"] }

    /// User
    ///
    /// Parent Type: `UserCore`
    public struct User: GitLabAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.UserCore }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("timelogs", Timelogs?.self, arguments: ["sort": "SPENT_AT_DESC"]),
      ] }

      /// Time logged by the user.
      public var timelogs: Timelogs? { __data["timelogs"] }

      /// User.Timelogs
      ///
      /// Parent Type: `TimelogConnection`
      public struct Timelogs: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.TimelogConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// User.Timelogs.Node
        ///
        /// Parent Type: `Timelog`
        public struct Node: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Timelog }
          public static var __selections: [ApolloAPI.Selection] { [
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

          /// User.Timelogs.Node.Project
          ///
          /// Parent Type: `Project`
          public struct Project: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Project }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("fullPath", GitLabAPI.ID.self),
              .field("nameWithNamespace", String.self),
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
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Issue }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("iid", String.self),
            ] }

            /// Internal ID of the issue.
            public var iid: String { __data["iid"] }
          }

          /// User.Timelogs.Node.MergeRequest
          ///
          /// Parent Type: `MergeRequest`
          public struct MergeRequest: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.MergeRequest }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("iid", String.self),
            ] }

            /// Internal ID of the merge request.
            public var iid: String { __data["iid"] }
          }
        }
      }
    }
  }
}
