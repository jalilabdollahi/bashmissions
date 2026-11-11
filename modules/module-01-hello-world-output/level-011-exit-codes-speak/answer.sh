#!/usr/bin/env bash
# The monitoring wall reads the exit status, not the text.
echo "CRITICAL: order queue is backed up"
exit 2
# Anything below exit never runs.
echo "all clear"
