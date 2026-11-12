#!/usr/bin/env bash
# No stray temp files next to the config, none in $TMPDIR, and the installed
# file must be readable by everyone (mktemp files start private: mode 600).
if [[ -n $(ls -A "$TMPDIR") ]]; then
  echo "Something was left in \$TMPDIR."
  exit 1
fi
leftover=$(ls -A config | grep -v '^app\.conf$' || true)
if [[ -n $leftover ]]; then
  echo "A temporary file was left in config/: $leftover. Remove it on the failure path or move it into place."
  exit 1
fi
if [[ $BM_EXIT == 0 && -z $(find config/app.conf -perm 644) ]]; then
  echo "config/app.conf should have mode 644 (rw-r--r--); mktemp creates private files, so chmod 644 before moving it into place."
  exit 1
fi
