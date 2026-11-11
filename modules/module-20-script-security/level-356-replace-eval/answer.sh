#!/usr/bin/env bash
# logsearch without eval: the command is an array, the words are checked.
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh PATTERN [OPTION...]" >&2
  exit 2
fi

pattern=$1
shift

flags=()
for word in "$@"; do
  case $word in
    ignore-case) flags+=(-i) ;;
    count)       flags+=(-c) ;;
    invert)      flags+=(-v) ;;
    *)
      # Anything we did not list never reaches a command line.
      printf 'unknown option: %s\n' "$word" >&2
      exit 2
      ;;
  esac
done

# -F: fixed text, not a regex. -e: the next word is the pattern, even if it
# starts with a dash. Each array element stays exactly one argument.
grep "${flags[@]}" -F -e "$pattern" logs/app.log
