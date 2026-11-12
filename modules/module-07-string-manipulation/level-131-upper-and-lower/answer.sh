#!/usr/bin/env bash
set -euo pipefail

mac=$1

# ^^ upper-cases every letter, ,, lower-cases every letter.
# Digits and colons have no case, so they pass through unchanged.
echo "dhcp=${mac^^}"
echo "inventory=${mac,,}"
