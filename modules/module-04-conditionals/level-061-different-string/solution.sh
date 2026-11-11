#!/usr/bin/env bash
# Guard for the nightly report: it may only run on the host named "dory".
# $1 is the current host name.

# TODO: if the host is NOT exactly "dory", print the refusal to stderr (>&2)
#       and stop with exit status 1
# TODO: otherwise print the starting line
