#!/usr/bin/env bash
# Deploy helper. The ":" command does nothing and always succeeds; it exists
# so that the ${...:=...} expansion has a place to run. As a side effect the
# expansion stores the default in REGION when it was unset or empty.
: "${REGION:=north-pier}"

# From here on REGION is an ordinary variable that always has a value.
echo "deploying to $REGION"
echo "backups: /backups/$REGION"
echo "tag: release-$REGION"
