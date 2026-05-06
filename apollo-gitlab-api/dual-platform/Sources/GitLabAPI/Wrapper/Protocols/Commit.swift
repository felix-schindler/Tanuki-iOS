import Foundation

public protocol NewCommit {
    var id: String { get }
    var title: String? { get }
    var shortId: String { get }
    var authorName: String? { get }
    var authoredDate: String? { get }
    var webUrl: String { get }
    var _signatureVerificationStatus: String? { get }
    var _lastPipelineStatus: GraphQLEnum<PipelineStatusEnum>? { get }
}
