#!/usr/bin/env bash
# Print the volumes in "$1" (host,mount,used_gb) with the fullest first.
# Equal sizes: alphabetical by host.

# TODO 1: tell sort the lines are comma-separated.
# TODO 2: first key is the used_gb field, compared as a number, biggest first.
# TODO 3: second key is the host field, ordinary text order.
