#if !os(Android)
import IOSGitLabAPI

extension IOSGitLabAPI.ProjectsQuery.Data.Projects.Node: GitLabProjectProtocol {}
#endif
