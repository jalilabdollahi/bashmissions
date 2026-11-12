#!/usr/bin/env bash
# After a collect, the evidence copies must be read-only and the sources untouched.
set -u
if [[ $BM_TEST_NAME == "collect two files, skip a folder" ]]; then
  bad=$(find case/evidence -type f -perm -0200 | head -1)
  if [[ -n $bad ]]; then
    echo "evidence file is still writable: $bad (chmod 0444 after copying)"
    exit 1
  fi
  [[ -f incident/auth.log && -f incident/syslog ]] || { echo "the original files must stay where they are (copy, do not move)"; exit 1; }
fi
exit 0
