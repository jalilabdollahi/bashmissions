#!/usr/bin/env bash
# No "set -e": sync-tool is allowed to fail and we want its status, not a crash.
target=$1

# Order matters. Read left to right:
#   > sync.log   fd 1 now points at the file
#   2>&1         fd 2 becomes a copy of fd 1, i.e. also the file
# Written the other way round, fd 2 would copy the TERMINAL first.
status=0
sync-tool "$target" > sync.log 2>&1 || status=$?

echo "sync exit status: $status"
