#!/usr/bin/env bash
# ticket.sh CUSTOMER SUBJECT - print a one-line ticket stub for Noor.
set -euo pipefail

usage() {
  cat <<'TXT'
Usage: ticket.sh CUSTOMER SUBJECT
Prints a one-line ticket stub.
TXT
}

# ${1:-} keeps "set -u" quiet when no argument was given at all.
case "${1:-}" in
  -h|--help)
    usage            # asked for help: this is normal output, status 0
    exit 0
    ;;
esac

if [ "$#" -ne 2 ]; then
  usage >&2          # a mistake: the text belongs on stderr, status 2
  exit 2
fi

echo "ticket for $1: $2"
