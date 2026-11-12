#!/usr/bin/env bash
set -euo pipefail

file=${1:-}
if [[ ! -r $file ]]; then
  echo "cannot read $file" >&2
  exit 1
fi

while IFS='=' read -r name value || [[ -n $name ]]; do
  name=${name#"${name%%[![:space:]]*}"};     name=${name%"${name##*[![:space:]]}"}
  value=${value:-}
  value=${value#"${value%%[![:space:]]*}"};  value=${value%"${value##*[![:space:]]}"}
  [[ -n $name && $name != \#* ]] || continue

  case ${name^^} in
    *_KEY|*_TOKEN|*_SECRET|*_PASSWORD)
      if (( ${#value} >= 12 )); then
        value="****${value: -4}"           # the space before -4 is required
      elif [[ -n $value ]]; then
        value="****"
      fi
      ;;
    *)
      # (anything up to ://user:) + password + (@ and the rest)
      if [[ $value =~ ^(.*://[^:/@]*:)[^@/]*(@.*)$ ]]; then
        value="${BASH_REMATCH[1]}****${BASH_REMATCH[2]}"
      fi
      ;;
  esac

  echo "$name=$value"
done < "$file"
