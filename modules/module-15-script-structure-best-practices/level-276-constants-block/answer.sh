#!/usr/bin/env bash
# backup-path.sh HOST DATE - say where tonight's backup of HOST should be written.
set -euo pipefail

# --- Constants --------------------------------------------------------------
# readonly sets the value and forbids any later assignment. Because the script
# assigns them unconditionally, a BACKUP_ROOT exported by the caller is
# overwritten, not trusted.
readonly BACKUP_ROOT=/srv/backups
readonly KEEP_DAYS=14
readonly SUFFIX=tar.gz
# ----------------------------------------------------------------------------

if [ "$#" -lt 2 ]; then
  echo "usage: solution.sh HOST DATE" >&2
  exit 2
fi

echo "path=$BACKUP_ROOT/$1/$2.$SUFFIX"
echo "keep=$KEEP_DAYS days"
