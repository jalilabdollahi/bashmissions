#!/usr/bin/env bash
# key=value ("logfmt") log line builder.
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh LEVEL MESSAGE [key=value ...]" >&2
  exit 2
fi

level=${1,,}
msg=$2
shift 2

case $level in
  debug|info|warn|error) ;;
  *) echo "bad level: $level" >&2; exit 2 ;;
esac

if [[ -n ${NOW:-} ]]; then
  stamp=$NOW
else
  printf -v stamp '%(%Y-%m-%dT%H:%M:%SZ)T' -1
fi

msg=${msg//\"/\\\"}                       # escape double quotes inside the message
line="time=$stamp level=$level msg=\"$msg\""

for field in "$@"; do
  if [[ $field != *=* ]]; then
    echo "bad field: $field" >&2
    exit 2
  fi
  key=${field%%=*}
  value=${field#*=}
  if [[ $value == *" "* ]]; then
    value="\"$value\""                    # quote only when a parser would be confused
  fi
  line+=" $key=$value"
done

printf '%s\n' "$line"
