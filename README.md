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
 GraphQL                45         1257         1208            1           48
 JSON                    4           65           65            0            0
 Swift                  86        14489        12667          640         1182
===============================================================================
 Total                 135        15811        13940          641         1230
===============================================================================
```
