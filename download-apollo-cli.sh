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
	need_cmd mkdir
	need_cmd rm
	need_cmd rmdir
	need_cmd tar

	# Determine the latest release version
	LATEST_VERSION=$(curl -Ls -o /dev/null -w %{url_effective} \
		"https://github.com/$REPOSITORY_OWNER/$REPOSITORY_NAME/releases/latest")
	LATEST_VERSION=${LATEST_VERSION##*/tag/}

	if [ -z "${VERSION:-}" ]; then
		DOWNLOAD_VERSION=$LATEST_VERSION
	else
		DOWNLOAD_VERSION=$VERSION
	fi

	local _url="https://github.com/$REPOSITORY_OWNER/$REPOSITORY_NAME/releases/download/${DOWNLOAD_VERSION}/${ARCHIVE_NAME}"
	local _tmpdir
	_tmpdir="$(mktemp -d 2>/dev/null || mktemp -d -t "${REPOSITORY_NAME}")"
	local _file="$_tmpdir/${ARCHIVE_NAME}"

	say "downloading $ARCHIVE_NAME from $_url" 1>&2

	ensure mkdir -p "$_tmpdir"
	downloader "$_url" "$_file"
	if [ $? != 0 ]; then
		say "failed to download $_url"
		say "this may be a standard network error"
		exit 1
	fi

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

	ignore rm -rf "$_tmpdir"
	say "successfully installed $BINARY_NAME" 1>&2
}

# Utility functions -----------------------------------------------------------

say() {
	local green
	green=$(tput setaf 2 2>/dev/null || echo '')
	local reset
	reset=$(tput sgr0 2>/dev/null || echo '')
	echo "${green}$1${reset}"
}

err() {
	local red
	red=$(tput setaf 1 2>/dev/null || echo '')
	local reset
	reset=$(tput sgr0 2>/dev/null || echo '')
	say "${red}ERROR${reset}: $1" >&2
	exit 1
}

need_cmd() {
	if ! check_cmd "$1"; then
		err "need '$1' (command not found)"
	fi
}

check_cmd() {
	command -v "$1" >/dev/null 2>&1
	return $?
}

need_ok() {
	if [ $? != 0 ]; then err "$1"; fi
}

# Run a command that should never fail. If it does, exit with an error.
ensure() {
	"$@"
	need_ok "command failed: $*"
}

# Intentionally ignore the result of a command.
ignore() {
	"$@"
}

# Download using curl or wget.
downloader() {
	if check_cmd curl; then
		_dld=curl
	elif check_cmd wget; then
		_dld=wget
	else
		_dld='curl or wget' # used in error message
	fi

	if [ "$1" = --check ]; then
		need_cmd "$_dld"
	elif [ "$_dld" = curl ]; then
		curl -sSfL "$1" -o "$2"
	elif [ "$_dld" = wget ]; then
		wget -q "$1" -O "$2"
	else
		err "Unknown downloader"
	fi
}

# -----------------------------------------------------------------------------

download_and_extract "$@" || exit 1
