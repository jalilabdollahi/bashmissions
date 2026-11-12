#!/usr/bin/env bash
# Rolling restart: restart SERVICE on each host in turn, wait until it reports
# "active" (at most 3 checks), and stop the whole rollout at the first failure.

# TODO: usage, readable host file, a sane service name
# TODO: read the hosts into an array first (you need to know how many are left)
# TODO: for each host: print, restart over ssh, bail out if the restart fails
# TODO: up to 3 is-active checks; remember the last state you saw
# TODO: abort = message on stderr with the number of untouched hosts, exit 1
# TODO: otherwise the "complete" line
