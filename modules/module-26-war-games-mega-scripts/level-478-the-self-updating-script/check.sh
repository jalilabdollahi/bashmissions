#!/usr/bin/env bash
# After the script ran: the file at $0 must still be a working script, and it must have the version
# the test expects. No half-written .new file may remain.
expected="lantern 1.0.0"
case $BM_TEST_NAME in
  "an update replaces the script") expected="lantern 1.2.0" ;;
  "rollback restores the previous version") expected="lantern 0.9.5" ;;
esac
got=$(bash solution.sh version 2> /dev/null || true)
if [[ $got != "$expected" ]]; then
  echo "After this run 'solution.sh version' printed '$got', expected '$expected'."
  exit 1
fi
if [[ -e solution.sh.new ]]; then
  echo "solution.sh.new was left behind. Move it into place or remove it."
  exit 1
fi
exit 0
