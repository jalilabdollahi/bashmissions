#!/usr/bin/env bash
set -euo pipefail
# Release packaging: give every dist/*.tar a NAME-VERSION-... name and write
# dist/MANIFEST.txt with "checksum size name" lines from cksum.

# TODO 1: validate NAME and VERSION (usage message, exit 2).
# TODO 2: collect dist/*.tar; if the glob matched nothing, say so and exit 1.
# TODO 3: rename the ones that do not start with NAME-VERSION- yet.
# TODO 4: cd into dist and run cksum on the tar files (names only), writing a
#         temporary file first, then move it to MANIFEST.txt.
# TODO 5: print how many artifacts the manifest lists.
