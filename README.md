# Tanuki

This is my [GitLab App](https://gitlab.com/felix-schindler/gitlab-ios),
reimagined with the power of GraphQL.

My goal is to merge these changes back to the original project and then use a
mix of REST-API v4 and GraphQL to deliver the best usibility with the most
features.

## GraphQL

To fetch the latest schema and regenerate the API code, run:

```bash
make generate-apollo
```

This downloads `apollo-ios-cli` if it is missing, refreshes `schema.graphqls`
from the GitLab GraphQL endpoint, and regenerates `apollo-gitlab-api/Sources`.
Run `make fetch-schema` if you only want to refresh the schema. Commit the
resulting changes. Set `VERSION=x.y.z` when running
`make install-apollo-cli` to pin a specific CLI release instead of latest.

Codegen writes only `apollo-gitlab-api/Sources`. The package manifest
`apollo-gitlab-api/Package.swift` is maintained by hand and is deliberately not
generated: it pins the `apollo-skip-fuse` fork instead of upstream `apollo-ios`.
Committed generated sources are kept exactly as the generator emits them, so
`make fmt` and `make lint` cover hand-written sources only.

## Development

Common tasks are defined in the `Makefile`. Run `make` to list them:

| Target | Description |
| ------------------ | ---------------------------------------------------- |
| `make fmt` | Format hand-written Swift sources in place |
| `make lint` | Lint hand-written Swift sources without modifying them |
| `make check` | Format, then lint (pre-commit gate) |
| `make icons` | Regenerate the bundled Android symbol assets |
| `make sbom` | Regenerate the bundled SPDX bill of materials |
| `make generate-apollo` | Fetch the GitLab schema and regenerate the API |
| `make fetch-schema` | Refetch `schema.graphqls` only |
| `make install-apollo-cli` | Download `apollo-ios-cli` (`VERSION=x.y.z` to pin) |
| `make check-generated` | Fail if the committed generated code is stale |
| `make clean` | Remove built artifacts |

`make check-generated` regenerates everything and fails if the committed
schema or generated sources differ, which is useful as a CI gate.

## Tokei

```txt
===============================================================================
 Language            Files        Lines         Code     Comments       Blanks
===============================================================================
 GraphQL                45         1257         1208            1           48
 JSON                    4           65           65            0            0
 Swift                  86        14489        12667          640         1182
===============================================================================
 Total                 135        15811        13940          641         1230
===============================================================================
```

# Feature comparison

| Feature                          | Tanuki | Gitblur | Gitblur Pro |
| -------------------------------- | ------ | ------- | ----------- |
| Price                            | 0,99€  | Free    | 69,99€      |
| **Projects**                     |        |         |             |
| Browsing                         | ✅     | ✅      | ✅          |
| Search and Filtering             | ✅     | ✅      | ✅          |
| Star and Fork                    | ❌     | ✅      | ✅          |
| Wiki browsing                    | ❌     | ✅      | ✅          |
| Share                            | ✅     | ✅      | ✅          |
| Create Project                   | ✅     | ❌      | ✅          |
| Project Settings                 | ❌     | ❌      | ✅          |
| Project Download                 | ❌     | ❌      | ✅          |
| CI/CD                            | ❌     | ❌      | ✅          |
| Invite Member                    | ❌     | ❌      | ✅          |
| Invite Group                     | ❌     | ❌      | ✅          |
| Wiki Management                  | ❌     | ❌      | ✅          |
| Create Snippet                   | ❌     | ❌      | ✅          |
| **Repository**                   |        |         |             |
| Tree Browsing                    | ✅     | ✅      | ✅          |
| Showing Changed Files            | ✅     | ✅      | ✅          |
| Source Code Browsing             | ✅     | ❌      | ✅          |
| Code Editor                      | ❌     | ❌      | ✅          |
| Create File, Branch, Tag         | ❌     | ❌      | ✅          |
| Import, Export Files             | ❌     | ❌      | ✅          |
| **Merge Requests**               |        |         |             |
| Browsing                         | ✅     | ✅      | ✅          |
| Search and Filter                | ❌     | ✅      | ✅          |
| Emoji Reaction                   | ❌     | ✅      | ✅          |
| Create, Delete, Close, Edit      | ⚠️     | ❌      | ✅          |
| Merge Action                     | ✅     | ❌      | ✅          |
| Mark as Draft                    | ❌     | ❌      | ✅          |
| Add Comments (supports Markdown) | ❌     | ❌      | ✅          |
| **Issues**                       |        |         |             |
| Browsing                         | ✅     | ✅      | ✅          |
| Search and Filter                | ✅     | ✅      | ✅          |
| Create, Delete, Close, Edit      | ⚠️     | ❌      | ✅          |
| Add Comments (supports Markdown) | ❌     | ❌      | ✅          |
| **Groups**                       |        |         |             |
| Browsing                         | ✅     | ✅      | ✅          |
| Create Group                     | ❌     | ❌      | ✅          |
| Create Project                   | ✅     | ❌      | ✅          |
| Create Subgroup                  | ❌     | ❌      | ✅          |
| Group Settings                   | ❌     | ❌      | ✅          |
| **Others**                       |        |         |             |
| Todo Browsing                    | ✅     | ✅      | ✅          |
| Keys Browsing                    | ❌     | ✅      | ✅          |
| Email Management                 | ❌     | ✅      | ✅          |
| Keys Management                  | ❌     | ✅      | ✅          |
| Todo Management                  | ❌     | ❌      | ✅          |
| Multi Account                    | ❌     | ❌      | ✅          |
| View in Browser                  | ❌     | ❌      | ✅          |
| Push Notifications               | ❌     | ❌      | ✅          |
