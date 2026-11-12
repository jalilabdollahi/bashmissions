#!/usr/bin/env bash
# Price-label tool: solution.sh [-u] [-p PREFIX] [--] WORD...
set -euo pipefail

upper=0
prefix=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    -u|--upper)
      upper=1
      shift
      ;;
    -p|--prefix)
      if [ "$#" -lt 2 ]; then
        echo "solution.sh: option $1 needs a value" >&2
        exit 2
      fi
      prefix=$2
      shift 2             # the flag and its value
      ;;
    --)
      shift               # everything after this is a word, even if it starts with -
      break
      ;;
    -*)
      echo "solution.sh: unknown option: $1" >&2
      exit 2
      ;;
    *)
      break               # first positional: options are over
      ;;
  esac
done

if [ "$#" -eq 0 ]; then
  echo "usage: solution.sh [-u] [-p PREFIX] [--] WORD..." >&2
  exit 2
fi

for word in "$@"; do
  if [ "$upper" -eq 1 ]; then word=${word^^}; fi
  printf '%s%s\n' "$prefix" "$word"
done
