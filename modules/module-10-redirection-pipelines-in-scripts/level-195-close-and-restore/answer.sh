#!/usr/bin/env bash
site=$1

echo "build started: $site"

# 1. Remember where the screen is: fd 4 becomes a second name for fd 1.
exec 4>&1
# 2. From now on, everything this script (and its children) writes to
#    stdout goes into the file.
exec > build.log

echo "site=$site"
compile-site "$site"

# 3. Put stdout back by copying fd 4 onto fd 1, then close fd 4.
exec 1>&4 4>&-

lines=$(( $(wc -l < build.log) ))
echo "build finished: $lines lines in build.log"
