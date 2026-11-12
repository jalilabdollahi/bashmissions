#!/usr/bin/env bash
# Read new-hire accounts from a CSV (username,fullname,group,shell) and create
# them with useradd, skipping existing users and rejecting bad usernames.

# TODO: usage / readability checks
# TODO: read the file line by line, tracking the line number; skip the header and blanks
# TODO: split each line on commas; strip a trailing carriage return
# TODO: validate the username with a regex, skip names found in fixtures/etc/passwd
# TODO: call useradd -m -c ... -g ... -s ...; a failure must not stop the loop
# TODO: summary line, exit 1 when anything failed
