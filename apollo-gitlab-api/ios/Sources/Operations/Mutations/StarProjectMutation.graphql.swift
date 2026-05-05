// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct StarProjectMutation: GraphQLMutation {
  public static let operationName: String = "StarProject"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation StarProject($projectId: ProjectID!, $starred: Boolean!) { starProject(input: { projectId: $projectId, starred: $starred }) { __typename count } }"#
    ))

  public var projectId: ProjectID
  public var starred: Bool

  public init(
    projectId: ProjectID,
    starred: Bool
  ) {
    self.projectId = projectId
    self.starred = starred
  }

  @_spi(Unsafe) public var __variables: Variables? { [
    "projectId": projectId,
    "starred": starred
  ] }

  nonisolated public struct Data: GitLabAPI.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Mutation }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("starProject", StarProject?.self, arguments: ["input": [
        "projectId": .variable("projectId"),
        "starred": .variable("starred")
      ]]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      StarProjectMutation.Data.self
    ] }

    @available(*, deprecated, message: "**Status**: Experiment. Introduced in GitLab 16.7.")
    public var starProject: StarProject? { __data["starProject"] }

    /// StarProject
    ///
    /// Parent Type: `StarProjectPayload`
    nonisolated public struct StarProject: GitLabAPI.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.StarProjectPayload }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("count", String.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        StarProjectMutation.Data.StarProject.self
      ] }

      /// Number of stars for the project.
      public var count: String { __data["count"] }
    }
  }
}
