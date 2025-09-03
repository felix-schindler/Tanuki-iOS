// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GroupMilestonesQuery: GraphQLQuery {
  public static let operationName: String = "GroupMilestones"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GroupMilestones($fullPath: ID!) { group(fullPath: $fullPath) { __typename milestones(state: active, sort: CREATED_DESC) { __typename nodes { __typename iid state title description expired startDate dueDate stats { __typename closedIssuesCount totalIssuesCount } webPath } } } }"#
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

      public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Group }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("milestones", Milestones?.self, arguments: [
          "state": "active",
          "sort": "CREATED_DESC"
        ]),
      ] }

      /// Milestones of the group.
      public var milestones: Milestones? { __data["milestones"] }

      /// Group.Milestones
      ///
      /// Parent Type: `MilestoneConnection`
      public struct Milestones: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.MilestoneConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Group.Milestones.Node
        ///
        /// Parent Type: `Milestone`
        public struct Node: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Milestone }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("iid", GitLabAPI.ID.self),
            .field("state", GraphQLEnum<GitLabAPI.MilestoneStateEnum>.self),
            .field("title", String.self),
            .field("description", String?.self),
            .field("expired", Bool.self),
            .field("startDate", GitLabAPI.Time?.self),
            .field("dueDate", GitLabAPI.Time?.self),
            .field("stats", Stats?.self),
            .field("webPath", String.self),
          ] }

          /// Internal ID of the milestone.
          public var iid: GitLabAPI.ID { __data["iid"] }
          /// State of the milestone.
          public var state: GraphQLEnum<GitLabAPI.MilestoneStateEnum> { __data["state"] }
          /// Title of the milestone.
          public var title: String { __data["title"] }
          /// Description of the milestone.
          public var description: String? { __data["description"] }
          /// Expired state of the milestone (a milestone is expired when the due date is past the current date). Defaults to `false` when due date has not been set.
          public var expired: Bool { __data["expired"] }
          /// Timestamp of the milestone start date.
          public var startDate: GitLabAPI.Time? { __data["startDate"] }
          /// Timestamp of the milestone due date.
          public var dueDate: GitLabAPI.Time? { __data["dueDate"] }
          /// Milestone statistics.
          public var stats: Stats? { __data["stats"] }
          /// Web path of the milestone.
          public var webPath: String { __data["webPath"] }

          /// Group.Milestones.Node.Stats
          ///
          /// Parent Type: `MilestoneStats`
          public struct Stats: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.MilestoneStats }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("closedIssuesCount", Int?.self),
              .field("totalIssuesCount", Int?.self),
            ] }

            /// Number of closed issues associated with the milestone.
            public var closedIssuesCount: Int? { __data["closedIssuesCount"] }
            /// Total number of issues associated with the milestone.
            public var totalIssuesCount: Int? { __data["totalIssuesCount"] }
          }
        }
      }
    }
  }
}
