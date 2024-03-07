// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class ProjectReleasesQuery: GraphQLQuery {
  public static let operationName: String = "ProjectReleasesQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query ProjectReleasesQuery($fullPath: ID!) { project(fullPath: $fullPath) { __typename releases { __typename nodes { __typename id name description tagName releasedAt author { __typename avatarUrl name username } commit { __typename shortId } milestones { __typename nodes { __typename id title } } assets { __typename count links { __typename nodes { __typename id name url } } sources { __typename nodes { __typename url format } } } } } } }"#
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
        .field("releases", Releases?.self),
      ] }

      /// Releases of the project.
      public var releases: Releases? { __data["releases"] }

      /// Project.Releases
      ///
      /// Parent Type: `ReleaseConnection`
      public struct Releases: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.ReleaseConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Project.Releases.Node
        ///
        /// Parent Type: `Release`
        public struct Node: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Release }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", GitLabAPI.ReleaseID.self),
            .field("name", String?.self),
            .field("description", String?.self),
            .field("tagName", String?.self),
            .field("releasedAt", GitLabAPI.Time?.self),
            .field("author", Author?.self),
            .field("commit", Commit?.self),
            .field("milestones", Milestones?.self),
            .field("assets", Assets?.self),
          ] }

          /// Global ID of the release.
          public var id: GitLabAPI.ReleaseID { __data["id"] }
          /// Name of the release.
          public var name: String? { __data["name"] }
          /// Description (also known as "release notes") of the release.
          public var description: String? { __data["description"] }
          /// Name of the tag associated with the release.
          public var tagName: String? { __data["tagName"] }
          /// Timestamp of when the release was released.
          public var releasedAt: GitLabAPI.Time? { __data["releasedAt"] }
          /// User that created the release.
          public var author: Author? { __data["author"] }
          /// Commit associated with the release.
          public var commit: Commit? { __data["commit"] }
          /// Milestones associated to the release.
          public var milestones: Milestones? { __data["milestones"] }
          /// Assets of the release.
          public var assets: Assets? { __data["assets"] }

          /// Project.Releases.Node.Author
          ///
          /// Parent Type: `UserCore`
          public struct Author: GitLabAPI.SelectionSet {
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

          /// Project.Releases.Node.Commit
          ///
          /// Parent Type: `Commit`
          public struct Commit: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Commit }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("shortId", String.self),
            ] }

            /// Short SHA1 ID of the commit.
            public var shortId: String { __data["shortId"] }
          }

          /// Project.Releases.Node.Milestones
          ///
          /// Parent Type: `MilestoneConnection`
          public struct Milestones: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.MilestoneConnection }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("nodes", [Node?]?.self),
            ] }

            /// A list of nodes.
            public var nodes: [Node?]? { __data["nodes"] }

            /// Project.Releases.Node.Milestones.Node
            ///
            /// Parent Type: `Milestone`
            public struct Node: GitLabAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Milestone }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("id", GitLabAPI.ID.self),
                .field("title", String.self),
              ] }

              /// ID of the milestone.
              public var id: GitLabAPI.ID { __data["id"] }
              /// Title of the milestone.
              public var title: String { __data["title"] }
            }
          }

          /// Project.Releases.Node.Assets
          ///
          /// Parent Type: `ReleaseAssets`
          public struct Assets: GitLabAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.ReleaseAssets }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("count", Int?.self),
              .field("links", Links?.self),
              .field("sources", Sources?.self),
            ] }

            /// Number of assets of the release.
            public var count: Int? { __data["count"] }
            /// Asset links of the release.
            public var links: Links? { __data["links"] }
            /// Sources of the release.
            public var sources: Sources? { __data["sources"] }

            /// Project.Releases.Node.Assets.Links
            ///
            /// Parent Type: `ReleaseAssetLinkConnection`
            public struct Links: GitLabAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.ReleaseAssetLinkConnection }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("nodes", [Node?]?.self),
              ] }

              /// A list of nodes.
              public var nodes: [Node?]? { __data["nodes"] }

              /// Project.Releases.Node.Assets.Links.Node
              ///
              /// Parent Type: `ReleaseAssetLink`
              public struct Node: GitLabAPI.SelectionSet {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.ReleaseAssetLink }
                public static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("id", GitLabAPI.ID.self),
                  .field("name", String?.self),
                  .field("url", String?.self),
                ] }

                /// ID of the link.
                public var id: GitLabAPI.ID { __data["id"] }
                /// Name of the link.
                public var name: String? { __data["name"] }
                /// URL of the link.
                public var url: String? { __data["url"] }
              }
            }

            /// Project.Releases.Node.Assets.Sources
            ///
            /// Parent Type: `ReleaseSourceConnection`
            public struct Sources: GitLabAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.ReleaseSourceConnection }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("nodes", [Node?]?.self),
              ] }

              /// A list of nodes.
              public var nodes: [Node?]? { __data["nodes"] }

              /// Project.Releases.Node.Assets.Sources.Node
              ///
              /// Parent Type: `ReleaseSource`
              public struct Node: GitLabAPI.SelectionSet {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.ReleaseSource }
                public static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("url", String?.self),
                  .field("format", String?.self),
                ] }

                /// Download URL of the source.
                public var url: String? { __data["url"] }
                /// Format of the source.
                public var format: String? { __data["format"] }
              }
            }
          }
        }
      }
    }
  }
}
