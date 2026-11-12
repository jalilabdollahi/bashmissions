#!/usr/bin/env bash
# After the script ends the temporary folder must be empty: the scratch file is gone.
left=$(ls -A "$TMPDIR")
if [[ -n $left ]]; then
  echo "Scratch file(s) left behind in the temporary folder: $left"
  exit 1
fi
# If the uploader ran, it must have been handed a path in the temp folder.
if [[ -f .calls.log ]]; then
  path=$(sed -n 's/^path=//p' .calls.log | head -n 1)
  case $path in
    */.tmp/*) ;;
    *) echo "lanternupload was given '$path', which is not a file made by mktemp."; exit 1 ;;
  esac
fi
exit 0
