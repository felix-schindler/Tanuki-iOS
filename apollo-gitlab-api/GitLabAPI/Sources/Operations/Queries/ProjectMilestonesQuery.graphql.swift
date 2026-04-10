// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

public struct ProjectMilestonesQuery: GraphQLQuery {
  public static let operationName: String = "ProjectMilestones"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query ProjectMilestones($fullPath: ID!, $state: MilestoneStateEnum, $searchTitle: String, $includeAncestors: Boolean) { project(fullPath: $fullPath) { __typename milestones( state: $state searchTitle: $searchTitle includeAncestors: $includeAncestors ) { __typename nodes { __typename id iid state title description expired startDate dueDate stats { __typename closedIssuesCount totalIssuesCount } webPath } } } }"#
    ))

  public var fullPath: ID
  public var state: GraphQLNullable<GraphQLEnum<MilestoneStateEnum>>
  public var searchTitle: GraphQLNullable<String>
  public var includeAncestors: GraphQLNullable<Bool>

  public init(
    fullPath: ID,
    state: GraphQLNullable<GraphQLEnum<MilestoneStateEnum>>,
    searchTitle: GraphQLNullable<String>,
    includeAncestors: GraphQLNullable<Bool>
  ) {
    self.fullPath = fullPath
    self.state = state
    self.searchTitle = searchTitle
    self.includeAncestors = includeAncestors
  }

  @_spi(Unsafe) public var __variables: Variables? { [
    "fullPath": fullPath,
    "state": state,
    "searchTitle": searchTitle,
    "includeAncestors": includeAncestors
  ] }

  public struct Data: GitLabAPI.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("project", Project?.self, arguments: ["fullPath": .variable("fullPath")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      ProjectMilestonesQuery.Data.self
    ] }

    /// Find a project.
    public var project: Project? { __data["project"] }

    /// Project
    ///
    /// Parent Type: `Project`
    public struct Project: GitLabAPI.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Project }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("milestones", Milestones?.self, arguments: [
          "state": .variable("state"),
          "searchTitle": .variable("searchTitle"),
          "includeAncestors": .variable("includeAncestors")
        ]),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        ProjectMilestonesQuery.Data.Project.self
      ] }

      /// Milestones of the project.
      public var milestones: Milestones? { __data["milestones"] }

      /// Project.Milestones
      ///
      /// Parent Type: `MilestoneConnection`
      public struct Milestones: GitLabAPI.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.MilestoneConnection }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          ProjectMilestonesQuery.Data.Project.Milestones.self
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Project.Milestones.Node
        ///
        /// Parent Type: `Milestone`
        public struct Node: GitLabAPI.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Milestone }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", GitLabAPI.ID.self),
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
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            ProjectMilestonesQuery.Data.Project.Milestones.Node.self
          ] }

          /// ID of the milestone.
          public var id: GitLabAPI.ID { __data["id"] }
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

          /// Project.Milestones.Node.Stats
          ///
          /// Parent Type: `MilestoneStats`
          public struct Stats: GitLabAPI.SelectionSet {
            @_spi(Unsafe) public let __data: DataDict
            @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

            @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.MilestoneStats }
            @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("closedIssuesCount", Int?.self),
              .field("totalIssuesCount", Int?.self),
            ] }
            @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              ProjectMilestonesQuery.Data.Project.Milestones.Node.Stats.self
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
