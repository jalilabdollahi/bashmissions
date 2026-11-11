#!/usr/bin/env bash
set -euo pipefail

# join needs both inputs sorted on the key, with the same ordering join will
# use (plain byte order here, thanks to LC_ALL=C). Sort on field 1 only.
# <(...) makes the sorted output look like a file, so no temp files.
# join prints: key, remaining fields of file 1, remaining fields of file 2.
join -t, <(sort -t, -k1,1 "$1") <(sort -t, -k1,1 "$2")
