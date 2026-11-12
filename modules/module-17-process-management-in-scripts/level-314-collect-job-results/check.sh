#!/usr/bin/env bash
# 1. the scratch folder (inside $TMPDIR) must be gone;
# 2. the probes must have overlapped.
if [[ -n $(ls -A "$TMPDIR" 2>/dev/null) ]]; then
  echo "The scratch folder made by mktemp -d is still there: remove it when you are done."
  exit 1
fi
[[ -f .calls.log ]] || exit 0
starts=$(grep -c '^start ' .calls.log || true)
before_first_end=$(awk '/^end /{exit} /^start /{n++} END{print n+0}' .calls.log)
if (( starts > 1 && before_first_end < starts )); then
  echo "Some probes only started after another had finished: start them all, then wait."
  exit 1
fi
exit 0
