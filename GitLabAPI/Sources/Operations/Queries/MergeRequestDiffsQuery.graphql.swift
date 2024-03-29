// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class MergeRequestDiffsQuery: GraphQLQuery {
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
        .field("mergeRequest", MergeRequest?.self, arguments: ["iid": .variable("iid")]),
      ] }

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
          .field("diffStats", [DiffStat]?.self),
        ] }

        /// Details about which files were changed in this merge request.
        public var diffStats: [DiffStat]? { __data["diffStats"] }

        /// Project.MergeRequest.DiffStat
        ///
        /// Parent Type: `DiffStats`
        public struct DiffStat: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.DiffStats }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("path", String.self),
            .field("additions", Int.self),
            .field("deletions", Int.self),
          ] }

          /// File path, relative to repository root.
          public var path: String { __data["path"] }
          /// Number of lines added to this file.
          public var additions: Int { __data["additions"] }
          /// Number of lines deleted from this file.
          public var deletions: Int { __data["deletions"] }
        }
      }
    }
  }
}
