#!/usr/bin/env bash
# Archive one site's stats and config. $1 = site name, BACKUP_DIR = backup root.
# Four steps: make the folder, pull+sort the stats, copy the config, report.
# Whatever goes wrong, the script must stop at that step. Dory's backup was
# once reported as "archived" with an empty stats file; let's not repeat that.

# TODO: switch on strict mode on the line below the shebang, in one command.

mkdir -p "$BACKUP_DIR/$1"
pullstats "$1" | sort > "$BACKUP_DIR/$1/stats.txt"
cp "sites/$1.conf" "$BACKUP_DIR/$1/site.conf"
# TODO: print "archived SITE: N lines" (count the lines of stats.txt)
