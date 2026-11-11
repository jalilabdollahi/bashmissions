#!/usr/bin/env bash
# Theo's logsearch, as found in the repo. It glues a command line together as
# text and eval runs it. Rebuild it so no text is ever executed.
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh PATTERN [OPTION...]" >&2
  exit 2
fi

pattern=$1
shift
cmd="grep"
for word in "$@"; do
  # TODO: map ignore-case/count/invert to -i/-c/-v with case, collect them in
  # an array, and reject every other word with "unknown option: WORD".
  cmd="$cmd --$word"
done
eval "$cmd $pattern logs/app.log"
