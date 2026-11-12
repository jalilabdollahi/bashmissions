#!/usr/bin/env bash
# Port inventory: probe a fixed list of ports on each host and compare the open
# ones with the ports the host is supposed to expose.

# TODO: usage / readable files
# TODO: load the EXPECTED file into an associative array: host -> "22 80 443"
# TODO: for each host, probe the six ports with nc -z -w 1 (hide its errors)
# TODO: build the comma-joined open list; compare each port with the expectation
# TODO: print host line, deviation lines, and the final tally; exit 1 on deviations
