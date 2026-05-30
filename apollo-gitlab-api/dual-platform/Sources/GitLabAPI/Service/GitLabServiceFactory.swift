import Foundation

public enum GitLabService {
    /// Create a new service instance connected to the given GitLab host.
    ///
    /// - Parameter host: The GitLab instance hostname (e.g. `"gitlab.com"`).
    /// - Parameter token: A personal access token or OAuth token.
    /// - Returns: A service that works on both iOS and Android via Skip.
    public static func make(host: String, token: String) -> GitLabServiceType {
        GitLabServiceImpl(host: host, token: token)
    }
}
