#!/usr/bin/env bash
set -euo pipefail
# Read commit subjects on stdin and print a Markdown changelog for version $1,
# grouped into Breaking changes / Features / Fixes / Other.

# TODO 1: no version -> usage on stderr, exit 2.
# TODO 2: four empty arrays, one per section.
# TODO 3: for each stdin line: skip blanks and "Merge ..."; regex-match
#         type, optional (scope), optional !, and the text.
# TODO 4: build the bullet and push it onto the right array.
# TODO 5: print "## VERSION", then each non-empty section in order, or
#         "No changes." when all four are empty.
