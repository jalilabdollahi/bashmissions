#!/usr/bin/env bash
# Run one command on every host in a list and print the results with a host
# prefix. Down hosts and failing commands are reported, never fatal.

# TODO: usage (needs HOSTFILE and a command), readable host file
# TODO: loop over the host file, skipping blank lines and # comments
# TODO: run the command with ssh in unattended mode; keep output AND exit status
# TODO: print output lines prefixed with "host: "; 255 -> UNREACHABLE; other non-zero -> FAILED (exit N)
# TODO: count hosts, ok and failed; print the summary and set the exit status
