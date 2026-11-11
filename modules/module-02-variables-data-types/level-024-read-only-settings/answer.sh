#!/usr/bin/env bash
# Retention guard: lock the setting, then watch Bash defend it.

readonly RETENTION_DAYS=$KEEP_DAYS
echo "retention: $RETENTION_DAYS days"

# The careless line. Bash refuses it and reports "readonly variable" on
# stderr; the value stays what it was, so the next line shows the old number.
RETENTION_DAYS=$NEW_DAYS
echo "retention now: $RETENTION_DAYS days"
