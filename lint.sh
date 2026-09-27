#!/bin/sh
# Lints the hand-written app sources, exiting non-zero on findings so it can
# gate a commit. GitLabAPI/ is generated Apollo code and is deliberately left
# alone.
set -eu

CONFIG=./format.json
SOURCES=./Tanuki

# `swift format lint` writes to stderr and always exits 0, so decide it here.
findings=$(swift format lint -p -r --configuration "$CONFIG" $SOURCES 2>&1 || true)

if [ -n "$findings" ]; then
	printf '%s\n' "$findings" >&2
	printf '\nlint failed (%s findings) — run ./fmt.sh to fix\n' "$(printf '%s\n' "$findings" | wc -l | tr -d ' ')" >&2
	exit 1
fi

printf '%s\n' "lint passed"
