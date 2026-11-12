#!/usr/bin/env bash
# The evidence folder must be private (drwx------).
for d in incident-*; do
  [[ -f $d/MANIFEST ]] || continue   # only folders this run completed
  perms=$(ls -ld "$d" | cut -c1-10)
  if [[ $perms != drwx------ ]]; then
    echo "$d has permissions $perms; evidence folders must be mode 700 (drwx------)"
    exit 1
  fi
done
