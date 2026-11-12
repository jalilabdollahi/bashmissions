#!/usr/bin/env bash
set -euo pipefail

# ":-" (with the colon) also covers a variable that is set but empty.
log=${AUDIT_LOG:-audit.log}

audited() {
  local rc=0 words
  "$@" || rc=$?                         # run it; its failure is a fact to record
  # %q escapes spaces and shell metacharacters: a;b -> a\;b, * -> \*
  printf -v words '%q ' "$@"
  printf '%s: %s status=%d\n' "${USER:-unknown}" "${words% }" "$rc" >> "$log"
  return "$rc"
}

failed=0
while read -ra words; do
  (( ${#words[@]} > 0 )) || continue    # blank line
  audited "${words[@]}" || failed=1
done

exit "$failed"
