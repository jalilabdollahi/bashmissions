#!/usr/bin/env bash
set -euo pipefail

file=${1:-}
if [[ ! -r $file || -d $file ]]; then
  echo "cannot read $file" >&2
  exit 2
fi

passed=0 failed=0 skipped=0 todo=0 planned=0

while IFS= read -r line || [[ -n $line ]]; do
  # The plan: "1..N". Anything else that is not a result is ignored.
  if [[ $line =~ ^1\.\.([0-9]+) ]]; then
    planned=${BASH_REMATCH[1]}
    continue
  fi

  # "ok 3 - text", "not ok 4 text". Groups: 1 = status, 2 = number, 3 = description.
  # Anchoring at ^ keeps indented diagnostics and "# not ok" comments out.
  if [[ $line =~ ^(not\ ok|ok)[[:space:]]+([0-9]+)[[:space:]]*(-[[:space:]]*)?(.*)$ ]]; then
    status=${BASH_REMATCH[1]}
    num=${BASH_REMATCH[2]}
    desc=${BASH_REMATCH[4]}

    directive=""
    if [[ $desc =~ [[:space:]]#[[:space:]]*(SKIP|TODO)([[:space:]]|$) ]]; then
      directive=${BASH_REMATCH[1]}
      desc=${desc%% #*}          # drop the directive text from the description
    fi

    if [[ $status == ok ]]; then
      if [[ $directive == SKIP ]]; then
        skipped=$(( skipped + 1 ))
      else
        passed=$(( passed + 1 ))
      fi
    else
      if [[ $directive == TODO ]]; then
        todo=$(( todo + 1 ))
      else
        failed=$(( failed + 1 ))
        echo "FAIL $num: $desc"
      fi
    fi
  fi
done < "$file"

echo "passed=$passed failed=$failed skipped=$skipped todo=$todo"

ran=$(( passed + failed + skipped + todo ))
if (( planned != ran )); then
  echo "plan mismatch: planned $planned, ran $ran" >&2
  exit 3
fi
(( failed == 0 )) || exit 1
