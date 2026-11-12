#!/usr/bin/env bash
set -euo pipefail
# Keep the KEEP newest regular files in DIR and delete the rest.
# Rank by modification time WITHOUT ls: use [[ a -nt b ]] on a glob array.

# TODO 1: validate KEEP (digits only) and DIR (a directory).
# TODO 2: collect the candidate files with a glob into an array; skip anything
#         that is not a plain file or is a symlink.
# TODO 3: a file's rank = how many other files are newer than it (-nt), with
#         equal times decided by name. Rank below KEEP means "keep".
# TODO 4: print keep/remove per file; delete the others with rm -- "$file".
# TODO 5: print the summary.
