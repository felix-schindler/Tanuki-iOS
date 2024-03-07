// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GroupTimelogsQuery: GraphQLQuery {
  public static let operationName: String = "GroupTimelogs"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GroupTimelogs($fullPath: ID!) { group(fullPath: $fullPath) { __typename timelogs(sort: SPENT_AT_DESC) { __typename nodes { __typename id user { __typename avatarUrl name username } spentAt summary timeSpent project { __typename fullPath nameWithNamespace } issue { __typename iid } mergeRequest { __typename iid } } } } }"#
    ))

  public var fullPath: ID

  public init(fullPath: ID) {
    self.fullPath = fullPath
  }

  public var __variables: Variables? { ["fullPath": fullPath] }

  public struct Data: GitLabAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("group", Group?.self, arguments: ["fullPath": .variable("fullPath")]),
    ] }

    /// Find a group.
    public var group: Group? { __data["group"] }

    /// Group
    ///
    /// Parent Type: `Group`
    public struct Group: GitLabAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Group }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("timelogs", Timelogs.self, arguments: ["sort": "SPENT_AT_DESC"]),
      ] }

      /// Time logged on issues and merge requests in the group and its subgroups.
      public var timelogs: Timelogs { __data["timelogs"] }

      /// Group.Timelogs
      ///
      /// Parent Type: `TimelogConnection`
      public struct Timelogs: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.TimelogConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Group.Timelogs.Node
        ///
        /// Parent Type: `Timelog`
        public struct Node: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Timelog }
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

          /// Group.Timelogs.Node.User
          ///
          /// Parent Type: `UserCore`
          public struct User: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.UserCore }
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
            /// Username of the user. Unique within this instance of GitLab.
            public var username: String { __data["username"] }
          }

          /// Group.Timelogs.Node.Project
          ///
          /// Parent Type: `Project`
          public struct Project: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Project }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("fullPath", GitLabAPI.ID.self),
              .field("nameWithNamespace", String.self),
            ] }

            /// Full path of the project.
            public var fullPath: GitLabAPI.ID { __data["fullPath"] }
            /// Full name of the project with its namespace.
            public var nameWithNamespace: String { __data["nameWithNamespace"] }
          }

          /// Group.Timelogs.Node.Issue
          ///
          /// Parent Type: `Issue`
          public struct Issue: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Issue }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("iid", GitLabAPI.ID.self),
            ] }

            /// Internal ID of the issue.
            public var iid: GitLabAPI.ID { __data["iid"] }
          }

          /// Group.Timelogs.Node.MergeRequest
          ///
          /// Parent Type: `MergeRequest`
          public struct MergeRequest: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.MergeRequest }
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
