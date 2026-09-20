// @generated
// This file was automatically generated and should not be edited.

@_spi(Internal) import ApolloAPI

nonisolated public enum PipelineStatusEnum: String, EnumType {
  /// Pipeline has been created.
  case created = "CREATED"
  /// A resource (for example, a runner) that the pipeline requires to run is unavailable.
  case waitingForResource = "WAITING_FOR_RESOURCE"
  /// Pipeline is preparing to run.
  case preparing = "PREPARING"
  /// Pipeline is waiting for an external action.
  case waitingForCallback = "WAITING_FOR_CALLBACK"
  /// Pipeline has not started running yet.
  case pending = "PENDING"
  /// Pipeline is running.
  case running = "RUNNING"
  /// At least one stage of the pipeline failed.
  case failed = "FAILED"
  /// Pipeline completed successfully.
  case success = "SUCCESS"
  /// Pipeline is in the process of canceling.
  case canceling = "CANCELING"
  /// Pipeline was canceled before completion.
  case canceled = "CANCELED"
  /// Pipeline was skipped.
  case skipped = "SKIPPED"
  /// Pipeline needs to be manually started.
  case manual = "MANUAL"
  /// Pipeline is scheduled to run.
  case scheduled = "SCHEDULED"
}
