#!/usr/bin/env bash
# How big is a /P network? Take the prefix length from $1.
# Print the number of addresses and the number of usable hosts.

# TODO: how many host bits are there? (an IPv4 address has 32 bits in total)
# TODO: every host bit doubles the address count: raise 2 to that power
# TODO: usable hosts = addresses minus the two reserved ones
