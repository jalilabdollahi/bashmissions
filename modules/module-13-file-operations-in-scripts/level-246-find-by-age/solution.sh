#!/usr/bin/env bash
# In FOLDER (which has a .last-backup marker file) list:
#   old: files not modified for more than DAYS days
#   changed: files modified after the marker
# then print "summary: A old, B changed". Regular files only, never the marker.

# TODO: validate DAYS (>= 1) and check the marker exists
# TODO: find ... -type f -mtime +DAYS, but skip the marker itself
# TODO: find ... -type f -newer marker
# TODO: sort both lists, prefix the lines, count them
