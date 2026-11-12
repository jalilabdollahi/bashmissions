#!/usr/bin/env bash
echo "report for backup job"

set -x                       # trace begins: the next commands are printed
elapsed=$(( $2 - $1 ))
minutes=$(( elapsed / 60 ))
set +x                       # trace ends (this line is the last one traced)

echo "backup took ${minutes}m"
