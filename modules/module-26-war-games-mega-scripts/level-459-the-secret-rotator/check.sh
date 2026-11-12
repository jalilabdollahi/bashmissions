#!/usr/bin/env bash
# Extra safety checks for the rotator: no secret leaks, permissions intact,
# no leftover backup after a finished run.
fail() { echo "$1"; exit 1; }

if grep -q 'rot-' "$BM_STDOUT_FILE" "$BM_STDERR_FILE" 2>/dev/null; then
  fail "A new secret leaked to the terminal. Never print secrets."
fi
if [[ -f rotation.log ]] && grep -q 'rot-' rotation.log; then
  fail "A new secret leaked into rotation.log."
fi
for f in secrets/*.secret; do
  [[ -f $f ]] || continue
  mode=$(ls -l "$f" | cut -c1-10)
  [[ $mode == "-rw-------" ]] || fail "$f must be mode 600, it is $mode."
done
for f in conf/*.conf; do
  [[ -f $f ]] || continue
  mode=$(ls -l "$f" | cut -c1-10)
  [[ $mode == "-rw-r-----" ]] || fail "$f lost its permissions (now $mode). Copy the mode to the new file before mv."
done
for f in conf/*.rotate-bak; do
  [[ -e $f ]] && fail "Leftover backup $f: remove it when the rotation is finished or restore it on failure."
done
exit 0
