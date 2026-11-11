#!/usr/bin/env bash
# Announce the build, send EVERYTHING the script prints to build.log while
# compile-site runs, then bring stdout back and announce the result.
# Save the screen with a spare descriptor before you redirect.

site=$1

echo "build started: $site"

# TODO: save stdout (fd 1) in fd 4
# TODO: point stdout at build.log
echo "site=$site"
compile-site "$site"
# TODO: restore stdout and close the spare descriptor

lines=$(( $(wc -l < build.log) ))
echo "build finished: $lines lines in build.log"
