#!/usr/bin/env bash
# Only exported variables are copied into the environment of programs
# this script starts.

export REGION="$SITE"     # handed to children
SCRATCH="/srv/scratch/$SITE"   # kept to ourselves

bash fixtures/child.sh

echo "parent sees: REGION=[$REGION] SCRATCH=[$SCRATCH]"
