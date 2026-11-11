#!/usr/bin/env bash
# The script must not leave its temporary file behind.
if [[ -n $(ls -A "$TMPDIR") ]]; then
  echo "A temporary file was left in \$TMPDIR. Remove it when the script ends (rm -f, or a trap on EXIT)."
  exit 1
fi
