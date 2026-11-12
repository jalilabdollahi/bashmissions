#!/usr/bin/env bash
# lantern: a tool that updates itself. Its own version is the constant 1.0.0. The update
# distrusts the server: validate the version, never downgrade, verify the download,
# then swap the file with one atomic rename.
#   solution.sh version
#   solution.sh update [--check] [--force] [--channel NAME]
#   solution.sh rollback

# TODO: VERSION constant, usage (exit 2), the `version` command
# TODO: vercmp: compare X.Y.Z component by component as numbers (1.10.0 is newer than 1.9.0)
# TODO: update step 1-2: fetch VERSION with curl, validate it, compare (up to date / downgrade / --check)
# TODO: update step 3-4: scratch dir (mktemp -d + trap), download the script and its .cksum,
#       verify cksum, bash -n, and the version the new script reports
# TODO: update step 5: backup to $0.old, prepare $0.new with cp -p, mv over $0, print and exit at once
# TODO: rollback: mv $0.old over $0, print the version it reports
