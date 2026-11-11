#!/usr/bin/env bash
# backup-path.sh HOST DATE - say where tonight's backup of HOST should be written
# and how long it is kept. Settings are scattered; gather them into one block.
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "usage: solution.sh HOST DATE" >&2
  exit 2
fi

# TODO: replace the three values below with a readonly constants block at the
# top (BACKUP_ROOT, KEEP_DAYS, SUFFIX) and use the names here.
root=${BACKUP_ROOT:-/srv/backups}
echo "path=$root/$1/$2.tar.gz"
echo "keep=14 days"
