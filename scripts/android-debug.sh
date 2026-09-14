#!/usr/bin/env bash
#
# Android debugging helpers for Tanuki (a Skip Fuse app).
#
#   scripts/android-debug.sh log [n]      live app log (also mirrors Notify statuses)
#   scripts/android-debug.sh dump [n]     last n lines of the app log
#   scripts/android-debug.sh crash        the last native crash, with a demangle hint
#   scripts/android-debug.sh so           which built .so files exist and their Apollo symbol counts
#   scripts/android-debug.sh demangle S   demangle a Swift symbol from a stack trace
#
# Useful context:
#   * App log tag is de.schindlerfelix.GitLab/Tanuki (the `logger` in TanukiApp.swift).
#     Notify.status() writes every success/warning/error there too.
#   * Debug builds keep Swift symbols, so crash frames usually print the mangled name
#     ($s6Tanuki8HomeViewV19loadStarredProjects...yyF+124). `demangle` makes it readable.
#   * For a frame that only shows an address, it is relative to the library image; the
#     unstripped copies live in tanuki-app/.build/aarch64-unknown-linux-android28/debug/.

set -uo pipefail

APP_ID=de.schindlerfelix.GitLab
LOG_TAG="$APP_ID/Tanuki"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LIBDIR="$ROOT/tanuki-app/.build/aarch64-unknown-linux-android28/debug"
OBJDUMP="$(xcrun --find llvm-objdump 2>/dev/null || echo llvm-objdump)"

device() {
	adb devices | awk '/\tdevice$/{print $1; exit}'
}

DEV="$(device)"
if [ -z "$DEV" ]; then
	echo "error: no adb device connected (adb devices is empty)" >&2
	exit 1
fi

case "${1:-log}" in
log)
	# -s <tag>:* keeps only the tags listed after it.
	adb -s "$DEV" logcat -v color \
		-s "$LOG_TAG:*" "SkipUI:*" "libc:*" "DEBUG:*" "AndroidRuntime:*" \
		"System.err:*"
	;;
dump)
	adb -s "$DEV" logcat -d -v time \
		-s "$LOG_TAG:*" "SkipUI:*" "libc:*" "DEBUG:*" "AndroidRuntime:*" |
		tail -n "${2:-200}"
	;;
crash)
	echo "== crash buffer =="
	adb -s "$DEV" logcat -d -b crash | tail -n 120
	echo
	echo "== demangle hint =="
	echo "  scripts/android-debug.sh demangle '\$s6Tanuki...'"
	;;
so)
	if [ ! -d "$LIBDIR" ]; then
		echo "no Android build yet: $LIBDIR" >&2
		exit 1
	fi
	echo "== Apollo symbols defined per built library (exactly one image must define them) =="
	for f in "$LIBDIR"/*.so; do
		n="$(nm "$f" 2>/dev/null | grep -c 'Apollo')"
		printf '%-28s %s\n' "$(basename "$f")" "$n"
	done
	echo
	echo "== APK contents =="
	APK="$ROOT/tanuki-app/.build/Android/app/outputs/apk/debug/app-debug.apk"
	[ -f "$APK" ] && unzip -l "$APK" | grep -E '\.so$' | awk '{print $1, $4}'
	;;
demangle)
	shift
	printf '%s\n' "$@" | swift demangle --compact
	;;
*)
	sed -n '2,16p' "$0"
	exit 1
	;;
esac
