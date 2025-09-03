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
 JSON                    4           41           41            0            0
 Swift                  71        11813        10421          537          855
===============================================================================
 Total                 120        13109        11668          538          903
===============================================================================
```
