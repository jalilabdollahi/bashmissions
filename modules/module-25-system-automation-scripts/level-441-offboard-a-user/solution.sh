#!/usr/bin/env bash
# Offboard a departed employee: refuse system accounts, lock the login,
# archive the home folder, and print a short report. -n = dry run.

# TODO: optional -n flag, then USER and STAMP (usage -> exit 2)
# TODO: look the user up in fixtures/etc/passwd; unknown -> exit 1
# TODO: pull the UID out of the passwd line; below 1000 -> exit 3
# TODO: dry run: print the two "would ..." lines and stop
# TODO: usermod -L -s /usr/sbin/nologin, then tar the home folder if it exists
# TODO: print the four report lines
