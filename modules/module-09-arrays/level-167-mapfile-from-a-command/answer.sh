#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh DIR" >&2
  exit 2
fi
dir=$1

if [[ ! -d $dir ]]; then
  echo "not a directory: $dir" >&2
  exit 1
fi

# < <(...) is process substitution: Bash runs the command and hands mapfile
# its output like a file. Because mapfile itself runs in THIS shell, the
# array survives. "cmd | mapfile" would not.
mapfile -t confs < <(find "$dir" -maxdepth 1 -name '*.conf' | sort)

echo "found: ${#confs[@]}"
for path in "${confs[@]}"; do
  echo "${path##*/}"           # strip everything up to the last slash
done
