#!/usr/bin/env bash
# Compress *.log files older than DAYS into LOGDIR/archive/, safely: verify the
# .gz before the original disappears, and never overwrite an earlier archive.

# TODO: usage, numeric DAYS, existing LOGDIR
# TODO: find the old regular *.log files in the top folder only; sorted
# TODO: skip any log whose archive/NAME.gz is already there
# TODO: gzip -c to a .partial file, gzip -t it, mv it into place, then rm the original
# TODO: print archived/skipped lines and the summary
