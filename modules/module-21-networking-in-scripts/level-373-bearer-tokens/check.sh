#!/usr/bin/env bash
# The token must not leak: not to stdout/stderr, not into a file, not into the script.
if grep -q 'tok_' "$BM_STDOUT_FILE" "$BM_STDERR_FILE"; then
  echo "The token showed up in your output. Secrets must never be printed."
  exit 1
fi
leak=$(grep -rIl 'tok_' . --exclude-dir=.bm-bin --exclude-dir=fixtures --exclude='.calls.log' 2>/dev/null | head -1 || true)
if [[ -n $leak ]]; then
  echo "The token ended up in a file ($leak). Read it from LF_TOKEN; do not store or hard-code it."
  exit 1
fi
exit 0
