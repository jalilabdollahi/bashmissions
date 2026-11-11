#!/usr/bin/env bash
set -euo pipefail
# Find the nearest .lanternrc, starting in $1 and climbing towards $2 (the root,
# which is searched too but never left). Print its location relative to the root
# and the value of its "project" key.

# TODO 1: turn both arguments into real absolute paths (cd + pwd -P); complain
#         with exit 2 when one is not a directory or START is outside ROOT.
# TODO 2: loop: if "$dir/.lanternrc" is a regular file, remember it and stop;
#         if dir is the root, stop; otherwise dir becomes its parent (dirname).
# TODO 3: nothing found -> message on stderr, exit 1.
# TODO 4: read the project value, print the two lines.
