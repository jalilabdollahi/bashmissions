#!/usr/bin/env bash
# The staging directory must be removed when the script ends.
if [[ -n $(ls -A "$TMPDIR") ]]; then
  echo "A temporary folder was left in \$TMPDIR. Remove it at the end (rm -rf on the folder, ideally from a trap on EXIT)."
  exit 1
fi
