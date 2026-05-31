# Directory structure

```
.
├── config/                     — Contains graphql query files (.graphql)
├── dual-platform/              — Contains the Swift package library
└── scripts/                    — Contains the code generation script (build.ts, written in Deno/TypeScript)
```

Run `$ ./scripts/build.ts` to regenerate the Swift query structs and service extensions from the `.graphql` operation files.
