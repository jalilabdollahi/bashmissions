#!/usr/bin/env bash
# Strict mode: -e stop on a failing command, -u stop on an unset variable,
# -o pipefail stop when any stage of a pipeline fails.
set -euo pipefail

site=$1
dest="$BACKUP_DIR/$site"

mkdir -p "$dest"
pullstats "$site" | sort > "$dest/stats.txt"
cp "sites/$site.conf" "$dest/site.conf"

lines=$(wc -l < "$dest/stats.txt")
echo "archived $site: $(( lines )) lines"    # $(( )) strips the padding macOS wc adds
