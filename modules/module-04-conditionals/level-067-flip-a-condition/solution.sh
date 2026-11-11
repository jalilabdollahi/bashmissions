#!/usr/bin/env bash
# Firewall check: is the address in $1 absent from allowlist.txt?
# Print BLOCK for strangers, allow for listed addresses.

# TODO: search allowlist.txt for the address as a WHOLE line, dots as plain dots
#       (look at grep -q with -x and -F)
# TODO: flip the result with ! so the BLOCK branch is the "then" branch
