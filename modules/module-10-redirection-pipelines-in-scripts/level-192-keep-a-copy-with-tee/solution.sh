#!/usr/bin/env bash
# Run deploy-tool for the site in $1. Show everything it prints on the screen
# and also append it to deploy.log. Exit with the tool's own status.

site=$1

deploy-tool "$site"
# TODO: merge stderr into stdout, pipe into tee that appends to deploy.log
# TODO: make sure a failing deploy-tool still fails the script (pipefail)
