#!/usr/bin/env bash
# Nightly log archiver for Gus's report. Argument 1 is the log file.
# The script must stop at the first real failure but still be able to say
# "no fatal lines" about a clean log.

echo "start"

# TODO 1: report whether the log has FATAL in it (use an if around grep -q).
# TODO 2: turn on set -e near the top so a failing cp stops the script.

cp "$1" archive/log.copy
echo "done"
