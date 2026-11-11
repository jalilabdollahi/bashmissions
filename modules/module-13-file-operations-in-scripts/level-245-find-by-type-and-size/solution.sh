#!/usr/bin/env bash
# Under FOLDER report:  big: <regular files larger than BYTES>,
#                       empty: <zero-byte regular files>,
#                       folders: <number of sub-folders>
# Sizes in bytes, results sorted.

# TODO: validate FOLDER and BYTES (digits only)
# TODO: find -type f -size +${bytes}c, sorted, each line prefixed "big: "
# TODO: find -type f -size 0, sorted, each line prefixed "empty: "
# TODO: count sub-folders with find -type d (the starting folder is in that list!)
