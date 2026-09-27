#!/bin/sh
# Formats the hand-written app sources in place.
#
# Scoped to ./Tanuki on purpose: GitLabAPI/ holds generated Apollo code and has
# to be committed exactly as apollo-ios-cli emits it, never reformatted.
set -eu

CONFIG=./format.json
SOURCES=./Tanuki

swift format -p -r -i --configuration "$CONFIG" $SOURCES
