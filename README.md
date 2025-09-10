# Tanuki

This is my [GitLab App](https://gitlab.com/felix-schindler/gitlab-ios), reimagined with the power of GraphQL.

My goal is to merge these changes back to the original project and then use a mix of REST-API v4 and GraphQL to deliver the best usibility with the most features.

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
 GraphQL                45         1255         1206            1           48
 JSON                    6          115          115            0            0
 Shell                   2            2            2            0            0
 Swift                 295        24417        18940         2938         2539
-------------------------------------------------------------------------------
 Markdown                2           37            0           25           12
 |- BASH                 1            2            2            0            0
 (Total)                             39            2           25           12
===============================================================================
 Total                 350        25826        20263         2964         2599
===============================================================================
```
