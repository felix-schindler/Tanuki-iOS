// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct MergeRequestDiffsQuery: GraphQLQuery {
  public static let operationName: String = "MergeRequestDiffs"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query MergeRequestDiffs($fullPath: ID!, $iid: String!) { project(fullPath: $fullPath) { __typename mergeRequest(iid: $iid) { __typename diffStats { __typename path additions deletions } } } }"#
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

  nonisolated public struct Data: GitLabAPI.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("project", Project?.self, arguments: ["fullPath": .variable("fullPath")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      MergeRequestDiffsQuery.Data.self
    ] }

    /// Find a project.
    public var project: Project? { __data["project"] }

    /// Project
    ///
    /// Parent Type: `Project`
    nonisolated public struct Project: GitLabAPI.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.Project }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("mergeRequest", MergeRequest?.self, arguments: ["iid": .variable("iid")]),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        MergeRequestDiffsQuery.Data.Project.self
      ] }

      /// A single merge request of the project.
      public var mergeRequest: MergeRequest? { __data["mergeRequest"] }

      /// Project.MergeRequest
      ///
      /// Parent Type: `MergeRequest`
      nonisolated public struct MergeRequest: GitLabAPI.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.MergeRequest }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("diffStats", [DiffStat]?.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          MergeRequestDiffsQuery.Data.Project.MergeRequest.self
        ] }

        /// Details about which files were changed in the merge request.
        public var diffStats: [DiffStat]? { __data["diffStats"] }

        /// Project.MergeRequest.DiffStat
        ///
        /// Parent Type: `DiffStats`
        nonisolated public struct DiffStat: GitLabAPI.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { GitLabAPI.Objects.DiffStats }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("path", String.self),
            .field("additions", Int.self),
            .field("deletions", Int.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            MergeRequestDiffsQuery.Data.Project.MergeRequest.DiffStat.self
          ] }

          /// File path, relative to repository root.
          public var path: String { __data["path"] }
          /// Number of lines added to the file.
          public var additions: Int { __data["additions"] }
          /// Number of lines deleted from the file.
          public var deletions: Int { __data["deletions"] }
        }
      }
    }
  }
}
