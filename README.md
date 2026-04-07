# Tanuki

This is my [GitLab App](https://gitlab.com/felix-schindler/gitlab-ios),
reimagined with the power of GraphQL.

My goal is to merge these changes back to the original project and then use a
mix of REST-API v4 and GraphQL to deliver the best usibility with the most
features.

## GraphQL

To fetch the latest schema and generate the API code, run:

```bash
./apollo-ios-cli fetch-schema
./apollo-ios-cli generate
```

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
