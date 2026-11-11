#!/usr/bin/env bash
# Portability check: line 1 is #!/bin/sh and the script gives the same answer
# when run by a plain POSIX shell (dash if this machine has it).
if [ "$(head -n 1 solution.sh)" != '#!/bin/sh' ]; then
  echo "Line 1 must be exactly: #!/bin/sh"
  exit 1
fi
if [ "${BM_EXIT:-0}" != 0 ]; then
  exit 0   # error paths were already verified by the declarative checks
fi
posix_sh=$(command -v dash || command -v sh)
if ! got=$("$posix_sh" solution.sh "$@" 2>&1); then
  echo "Running the script with $posix_sh failed: $got"
  exit 1
fi
want=$(cat "$BM_STDOUT_FILE")
if [ "$got" != "$want" ]; then
  echo "Under $posix_sh the output differs from bash. Expected: $want -- got: $got"
  exit 1
fi
exit 0
