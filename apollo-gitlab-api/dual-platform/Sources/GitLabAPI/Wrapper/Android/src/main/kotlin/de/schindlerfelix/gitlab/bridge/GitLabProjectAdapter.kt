@file:JvmName("GitLabProjectAdapter")

package de.schindlerfelix.gitlab.bridge

import de.schindlerfelix.gitlab.api.ProjectsQuery
import git.lab.api.GitLabProject

public fun ProjectsQuery.Node.toGitLabProject(): GitLabProject = GitLabProject(
    fullPath = fullPath,
    nameWithNamespace = nameWithNamespace,
    avatarUrl = avatarUrl,
    visibility = visibility,
)
