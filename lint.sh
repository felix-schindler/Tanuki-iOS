#!/bin/sh
# Reports swift-format lint findings in the hand-written app sources, and exits
# non-zero if there are any, so this can gate a commit or a CI job.
#
# Scoped to ./Tanuki on purpose: GitLabAPI/ holds generated Apollo code and has
# to be committed exactly as apollo-ios-cli emits it, never reformatted.
set -eu

CONFIG=./format.json
SOURCES=./Tanuki

# `swift format lint` writes findings to stderr and always exits 0, so capture
# the output and decide the exit status here.
findings=$(swift format lint -p -r --configuration "$CONFIG" $SOURCES 2>&1 || true)

if [ -n "$findings" ]; then
	printf '%s\n' "$findings" >&2
	printf '\nlint failed (%s findings) — run ./fmt.sh to fix\n' "$(printf '%s\n' "$findings" | wc -l | tr -d ' ')" >&2
	exit 1
fi

printf '%s\n' "lint passed"
