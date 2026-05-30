# Directory structure

To fetch the latest schema and regenerate the iOS and Android libraries, run `$ ./generate.sh`.

```
.
├── config/                     — Contains graphql schema and queries
├── android/                    — Contains gradle build files for the generated gitlab-api-android
│   └── src/main/graphql/       — links to ./config/
├── ios/                        — Contains the generated GitLabAPI for iOS
├── dual-platform/              — Contains Skip Fuse library combining the generated GitLabAPI for Android and iOS
├── scripts/                    — Contains helper scripts (written in TS/deno) to update the whole library (update apollo, update schema, generate iOS and Android libraries, generate code for dual-platform library)
└── apollo-codegen-config.json  — Contains config for generating graphql schema and iOS library
```
