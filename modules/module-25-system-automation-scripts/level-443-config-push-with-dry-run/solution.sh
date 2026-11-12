#!/usr/bin/env bash
# Distribute one config file to every host in a list. With -n, only say what
# would happen. Refuse an unreadable or empty config before touching anything.

# TODO: optional -n, then exactly HOSTFILE LOCALFILE REMOTEPATH
# TODO: check LOCALFILE is readable and not empty
# TODO: loop over the hosts (skip blanks and comments)
# TODO: dry run -> print "would push ..." ; real run -> scp, then pushed/FAILED
# TODO: summary line for each mode; exit 1 if any real push failed
