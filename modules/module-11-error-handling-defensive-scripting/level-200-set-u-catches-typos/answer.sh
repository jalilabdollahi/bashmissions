#!/usr/bin/env bash
set -u    # using an unset variable is now an error, not an empty string

# DEPLOY_ROOT is required: if it is missing, set -u stops us right here.
# RELEASE_TAG is optional: ":-" supplies a default so set -u stays quiet.
target="$DEPLOY_ROOT/releases/${RELEASE_TAG:-latest}"
echo "would clear $target"
