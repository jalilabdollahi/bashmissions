#!/usr/bin/env bash
# enforce must leave sane permissions: shadow fixed to 0600, and the rewritten
# passwd file must keep its original mode (0644), not mktemp's 0600.
set -u
mode_of() { ls -ld "$1" | cut -c2-10; }
if [[ $BM_TEST_NAME == "enforce fixes, backs up and verifies" ]]; then
  [[ $(mode_of srv/etc/shadow) == rw------- ]] || { echo "srv/etc/shadow should be mode 0600, got $(mode_of srv/etc/shadow)"; exit 1; }
  [[ $(mode_of srv/etc/passwd) == rw-r--r-- ]] || { echo "srv/etc/passwd lost its mode (now $(mode_of srv/etc/passwd)); write the new content back over the old file instead of moving a mktemp file in"; exit 1; }
  [[ $(mode_of srv/.compliance-backup/etc/shadow) == rw-r--r-- ]] || { echo "the backup of shadow must keep the ORIGINAL mode 0644 (cp -p)"; exit 1; }
fi
if [[ $BM_TEST_NAME == "dry run changes nothing" ]]; then
  [[ $(mode_of srv/etc/shadow) == rw-r--r-- ]] || { echo "a dry run must not chmod anything"; exit 1; }
fi
exit 0
