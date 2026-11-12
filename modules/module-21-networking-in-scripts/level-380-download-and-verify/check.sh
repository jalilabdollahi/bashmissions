#!/usr/bin/env bash
# Only the verified file may remain: no .part files, no leftover checksum file,
# and nothing at all after a failure.
extra=$(find . -maxdepth 1 -type f ! -name 'solution.sh' ! -name '.*' | sed 's|^\./||' | sort)
if (( BM_EXIT == 0 )); then
  want=$1
else
  want=
fi
if [[ $extra != "$want" ]]; then
  echo "Expected these files in the directory: ${want:-(none)}"
  echo "But found: ${extra:-(none)}"
  echo "Download into a temporary file, and clean up whatever you do not keep."
  exit 1
fi
exit 0
