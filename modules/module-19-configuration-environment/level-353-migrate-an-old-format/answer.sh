#!/usr/bin/env bash
set -euo pipefail

if (( $# != 2 )); then
  echo "usage: solution.sh OLD_FILE NEW_FILE" >&2
  exit 2
fi
old=$1 new=$2

if [[ ! -r $old ]]; then
  echo "cannot read $old" >&2
  exit 1
fi

trim() {
  local s=$1
  s=${s#"${s%%[![:space:]]*}"}
  s=${s%"${s##*[![:space:]]}"}
  printf '%s' "$s"
}

# Idempotence: is this file already in the new format?
while IFS= read -r line || [[ -n $line ]]; do
  line=$(trim "$line")
  [[ -z $line || $line == \#* ]] && continue
  if [[ $line == "version=2" ]]; then
    echo "already v2: nothing to do"
    exit 0
  fi
  break                                  # the first real line decides
done < "$old"

if [[ -e $new ]]; then
  echo "refusing to overwrite $new" >&2
  exit 1
fi

# Convert everything into memory first; the new file is written in one go at the end,
# so a failure half way cannot leave a half-converted file behind.
out=()
count=0
lineno=0
while IFS= read -r line || [[ -n $line ]]; do
  lineno=$(( lineno + 1 ))
  line=$(trim "$line")
  [[ -n $line ]] || continue
  if [[ $line == \#* ]]; then
    out+=("$line")
    continue
  fi
  if [[ $line != *:* ]]; then
    echo "skipped line $lineno" >&2
    continue
  fi
  name=$(trim "${line%%:*}")             # before the first colon
  value=$(trim "${line#*:}")             # after it (may contain more colons)
  case $name in
    Listen)   out+=("port=$value") ;;
    Hostname) out+=("host=$value") ;;
    Debug)
      if [[ ${value,,} == on ]]; then out+=("log_level=debug"); else out+=("log_level=info"); fi
      ;;
    Timeout)  out+=("timeout_seconds=${value%s}") ;;
    *)
      echo "unknown key: $name (copied as lowercase)" >&2
      out+=("${name,,}=$value")
      ;;
  esac
  count=$(( count + 1 ))
done < "$old"

{
  echo "version=2"
  if (( ${#out[@]} > 0 )); then
    printf '%s\n' "${out[@]}"
  fi
} > "$new"
echo "migrated $count settings"
