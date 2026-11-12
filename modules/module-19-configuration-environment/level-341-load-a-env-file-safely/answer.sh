#!/usr/bin/env bash
set -euo pipefail

file=${1:-}
if [[ ! -r $file || -d $file ]]; then
  echo "cannot read $file" >&2
  exit 1
fi

lineno=0
# "|| [[ -n $line ]]" keeps a last line that has no trailing newline.
while IFS= read -r line || [[ -n $line ]]; do
  lineno=$(( lineno + 1 ))

  # Blank lines and comments carry no setting.
  if [[ $line =~ ^[[:space:]]*(#.*)?$ ]]; then
    continue
  fi

  # KEY, optional blanks, "=", then the rest of the line (which may hold more "=").
  if [[ $line =~ ^[[:space:]]*([A-Za-z_][A-Za-z0-9_]*)[[:space:]]*=(.*)$ ]]; then
    key=${BASH_REMATCH[1]}
    value=${BASH_REMATCH[2]}
  else
    echo "skipped line $lineno" >&2
    continue
  fi

  # Trim blanks on both sides of the value.
  value=${value#"${value%%[![:space:]]*}"}
  value=${value%"${value##*[![:space:]]}"}

  # Remove ONE matching pair of quotes (glob tests, no evaluation involved).
  if (( ${#value} >= 2 )); then
    if [[ $value == \"*\" || $value == \'*\' ]]; then
      value=${value:1:${#value}-2}
    fi
  fi

  # export with a "key=value" string stores the text as it is; nothing is expanded
  # a second time, which is exactly what "source" would have done.
  export "$key=$value"
done < "$file"

echo "name=${SITE_NAME:-(unset)}"
echo "port=${SITE_PORT:-(unset)}"
echo "motd=${SITE_MOTD:-(unset)}"
