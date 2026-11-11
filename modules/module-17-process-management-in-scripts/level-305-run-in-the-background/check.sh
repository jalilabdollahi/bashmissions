#!/usr/bin/env bash
# Runs only after stdout and exit status were right.
# 1. All snapshots must have started before the first one ended (= parallel).
# 2. pids.txt must hold exactly the PIDs the snapshots really had.
(( $# == 0 )) && exit 0
if [[ ! -f .calls.log ]]; then
  echo "snapshot was never run."
  exit 1
fi
seen_end=0
starts=0
ends=0
while read -r word _; do
  case $word in
    start)
      starts=$((starts + 1))
      if (( seen_end )); then
        echo "A snapshot ended before the last one had started: they ran one after another."
        exit 1
      fi
      ;;
    end)
      seen_end=1
      ends=$((ends + 1))
      ;;
  esac
done < .calls.log
if (( starts != $# )); then
  echo "Expected $# snapshots to start, saw $starts."
  exit 1
fi
if (( ends != $# )); then
  echo "Only $ends of $# snapshots had finished when the script exited: wait for them."
  exit 1
fi
if [[ ! -f pids.txt ]]; then
  echo "pids.txt was not written."
  exit 1
fi
want=$(awk '$1 == "start" { print $3 }' .calls.log | sort)
have=$(sort pids.txt)
if [[ $want != "$have" ]]; then
  echo "pids.txt does not contain the PIDs of the snapshot processes (use \$! right after the &)."
  exit 1
fi
exit 0
