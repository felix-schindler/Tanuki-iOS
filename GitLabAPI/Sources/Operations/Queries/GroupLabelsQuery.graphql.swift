// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GroupLabelsQuery: GraphQLQuery {
  public static let operationName: String = "GroupLabels"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GroupLabels($fullPath: ID!) { group(fullPath: $fullPath) { __typename labels { __typename nodes { __typename id title description color textColor } } } }"#
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
        .field("labels", Labels?.self),
      ] }

      /// Labels available on this group.
      public var labels: Labels? { __data["labels"] }

      /// Group.Labels
      ///
      /// Parent Type: `LabelConnection`
      public struct Labels: GitLabAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.LabelConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// Group.Labels.Node
        ///
        /// Parent Type: `Label`
        public struct Node: GitLabAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitLabAPI.Objects.Label }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", GitLabAPI.ID.self),
            .field("title", String.self),
            .field("description", String?.self),
            .field("color", String.self),
            .field("textColor", String.self),
          ] }

          /// Label ID.
          public var id: GitLabAPI.ID { __data["id"] }
          /// Content of the label.
          public var title: String { __data["title"] }
          /// Description of the label (Markdown rendered as HTML for caching).
          public var description: String? { __data["description"] }
          /// Background color of the label.
          public var color: String { __data["color"] }
          /// Text color of the label.
          public var textColor: String { __data["textColor"] }
        }
      }
    }
  }
}
