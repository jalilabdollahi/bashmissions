#!/usr/bin/env bash
# Resolve hostnames and show the IPv4 addresses each one currently has.

# TODO: usage message and exit 2 without arguments
# TODO: per name run `dig +short NAME`; dig can fail, and that must not stop the loop
# TODO: keep only the lines that look like IPv4 addresses (aliases are noise)
# TODO: join the addresses with commas; print "NAME -> ..." with "no answer" / "lookup failed" variants
# TODO: exit 1 if any name was not resolved
