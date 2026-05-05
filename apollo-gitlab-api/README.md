# Directory structure

To fetch the latest schema and regenerate the iOS and Android libraries, run `$ ./generate.sh`.

```
.
├── config/                     — Contains graphql schema and queries
├── android/                    — Contains gradle build files for the generated gitlab-api-android
│   └── src/main/graphql/       — links to ./config/
├── ios/                        — Contains the generated GitLabAPI for iOS
├── dual-platform/              — Contains Skip Fuse library combining the generated GitLabAPI for Android and iOS
├── apollo-codegen-config.json  — Contains config for generating graphql schema and iOS library
├── download.sh                 — Helper script to download the latest apollo-ios-cli
└── generate.sh                 — Script to update and generate everything (except Apollo Kotlin version)
```
