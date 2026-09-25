#!/bin/bash
# The original script is from https://raw.githubusercontent.com/apollographql/apollo-kotlin-cli/main/install.sh
# with some minor modifications to work for apollo-ios. The original license is included below.
#
# Licensed under the MIT license
# <LICENSE-MIT or https://opensource.org/licenses/MIT>, at your
# option. This file may not be copied, modified, or distributed
# except according to those terms.

set -u

REPOSITORY_OWNER=apollographql
REPOSITORY_NAME=apollo-ios
ARCHIVE_NAME="apollo-ios-cli.tar.gz"
BINARY_NAME="apollo-ios-cli"

download_and_extract() {
	need_cmd curl
	need_cmd mktemp
	need_cmd chmod
	need_cmd rm
	need_cmd tar

	local _release="latest/download"
	if [ -n "${VERSION:-}" ]; then
		_release="download/$VERSION"
	fi

	local _url="https://github.com/$REPOSITORY_OWNER/$REPOSITORY_NAME/releases/${_release}/${ARCHIVE_NAME}"
	local _tmpdir
	_tmpdir="$(mktemp -d 2>/dev/null || mktemp -d -t "${REPOSITORY_NAME}")"
	local _file="$_tmpdir/${ARCHIVE_NAME}"

	say "downloading $ARCHIVE_NAME from $_url" 1>&2

	curl -sSfL "$_url" -o "$_file" || {
		say "failed to download $_url"
		say "this may be a standard network error"
		exit 1
	}

	say "extracting $ARCHIVE_NAME" 1>&2
	ensure tar -xzf "$_file" -C "$_tmpdir"

	# The archive is expected to contain a single binary. Locate it.
	local _binary_path
	_binary_path=$(find "$_tmpdir" -type f -name "$BINARY_NAME" | head -1)
	if [ -z "$_binary_path" ]; then
		_binary_path=$(find "$_tmpdir" -type f | head -1)
	fi

	if [ -z "$_binary_path" ]; then
		err "No executable binary found in the archive"
	fi

	say "placing $BINARY_NAME in current directory" 1>&2
	ensure cp "$_binary_path" "./$BINARY_NAME"
	ensure chmod +x "./$BINARY_NAME"

	rm -rf "$_tmpdir"
	say "successfully installed $BINARY_NAME" 1>&2
}

# Utility functions -----------------------------------------------------------

say() {
	echo "$1"
}

err() {
	echo "ERROR: $1" >&2
	exit 1
}

need_cmd() {
	if ! command -v "$1" >/dev/null 2>&1; then
		err "need '$1' (command not found)"
	fi
}

# Run a command that should never fail. If it does, exit with an error.
ensure() {
	"$@" || err "command failed: $*"
}

# -----------------------------------------------------------------------------

download_and_extract "$@" || exit 1
