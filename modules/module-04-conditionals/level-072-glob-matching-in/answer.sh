#!/usr/bin/env bash
set -euo pipefail

name="$1"

# On the right of == inside [[ ]], an UNQUOTED word is a glob pattern:
#   *  any number of characters     ?  exactly one character
# The ladder is checked top to bottom, so tmp-old.log hits rule 1 first.
if [[ $name == tmp-* ]]; then
  echo "$name -> delete"
elif [[ $name == *.log ]]; then
  echo "$name -> archive"
elif [[ $name == crash-?.dump ]]; then
  echo "$name -> ticket"
else
  echo "$name -> ignore"
fi
