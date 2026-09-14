# Directory structure

The GraphQL layer is pure Swift on both platforms: the operations in `config/` are
compiled into the `ios/` package by the **apollo-ios-cli bundled with the
[apollo-skip-fuse fork](https://github.com/felix-schindler/apollo-skip-fuse)**, which
runs Android via Skip Fuse — no Apollo Kotlin and no hand-written bridge.

To fetch the latest schema and regenerate, run `$ ./generate.sh` (add `--fetch-schema`
to refresh `config/schema.graphqls` from gitlab.com first).

```
.
├── config/                     — GraphQL schema (schema.graphqls) and query/mutation operations
├── ios/                        — Generated Swift package (IOSGitLabAPI), produced by apollo-ios-cli
├── dual-platform/              — Skip Fuse library: wrapper protocols, Apollo conformances, shared resources
├── apollo-codegen-config.json  — Codegen config for schema download and the generated package
└── generate.sh                 — Runs apollo-ios-cli and restores the fork dependency in ios/Package.swift
```

Note: the CLI rewrites the generated `ios/Package.swift` to depend on upstream
`apollographql/apollo-ios` on every run. `generate.sh` restores the committed fork
dependency afterwards; don't commit the upstream version.
