#!/bin/sh
# Formats the hand-written app sources in place. GitLabAPI/ is generated
# Apollo code and is deliberately left alone.
set -eu

CONFIG=./format.json
SOURCES=./Tanuki

swift format -p -r -i --configuration "$CONFIG" $SOURCES
