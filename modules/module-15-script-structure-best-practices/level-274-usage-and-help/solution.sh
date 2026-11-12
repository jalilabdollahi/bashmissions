#!/usr/bin/env bash
# ticket.sh CUSTOMER SUBJECT - print a one-line ticket stub for Noor.
# Right now it trusts its arguments blindly. Teach it to explain itself.
set -euo pipefail

# TODO 1: define usage() that prints the two usage lines.
# TODO 2: -h / --help as the first argument -> usage on stdout, exit 0.
# TODO 3: anything but exactly two arguments -> usage on stderr, exit 2.

echo "ticket for $1: $2"
