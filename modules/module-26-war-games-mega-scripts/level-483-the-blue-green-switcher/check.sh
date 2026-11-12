#!/usr/bin/env bash
# Verifies what the declarative checks cannot see: where the symlink points and
# that no temporary link was left behind (or dropped inside a release folder).
set -u
target() { ls -ld site/current | sed 's/.* -> //'; }
want=
case $BM_TEST_NAME in
  "switch to the idle slot") want=releases/green ;;
  "switch from green back to blue") want=releases/blue ;;
  "failed smoke test keeps the live slot") want=releases/blue ;;
  "rollback returns to the previous slot") want=releases/blue ;;
  "same version in both slots") want=releases/blue ;;
esac
if [[ -n $want ]]; then
  [[ -L site/current ]] || { echo "site/current must still be a symlink"; exit 1; }
  got=$(target)
  [[ $got == "$want" ]] || { echo "site/current points at '$got', expected '$want'"; exit 1; }
fi
strays=$(find site -name '.current.tmp*' -o -name 'current.new*' -o -type l -path 'site/releases/*' | head -1)
if [[ -n $strays ]]; then
  echo "left a stray link behind: $strays (mv -f onto a symlink to a directory moves INTO it; see the hints)"
  exit 1
fi
exit 0
