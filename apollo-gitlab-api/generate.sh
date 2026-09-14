#!/bin/bash
# Regenerates the Swift library from the .graphql operations in config/.
#
# Uses the apollo-ios-cli bundled with the apollo-skip-fuse fork. Run `make` in
# that checkout once to unpack the CLI if it is missing, or point APOLLO_IOS_CLI
# at another copy.
set -e
cd "$(dirname "$0")"

APOLLO_IOS_CLI="${APOLLO_IOS_CLI:-$HOME/Code/apollo-skip-fuse/apollo-ios-cli}"
if [ ! -x "$APOLLO_IOS_CLI" ]; then
	echo "apollo-ios-cli not found at $APOLLO_IOS_CLI" >&2
	echo "Run 'make' in the apollo-skip-fuse checkout, or set APOLLO_IOS_CLI." >&2
	exit 1
fi

# Optional: refresh config/schema.graphqls from gitlab.com first.
if [ "${1:-}" = "--fetch-schema" ]; then
	"$APOLLO_IOS_CLI" fetch-schema
fi

"$APOLLO_IOS_CLI" generate

# The CLI rewrites the generated swiftPackage manifest to depend on upstream
# apollographql/apollo-ios. Restore our committed fork dependency and re-resolve,
# otherwise resolution mixes upstream and fork copies of the same targets.
git checkout -- ./ios/Package.swift
(cd ./ios && swift package resolve)

echo "Done. Generated sources are in ./ios, fork manifest restored."
