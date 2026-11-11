#!/usr/bin/env bash
set -euo pipefail

# Inside a function, $1 and $2 are NOT the script's arguments: they are
# whatever was written after the function name in the call.
describe() {
  echo "$1 hosts $2 sites"
}

# Quotes keep "dory east" together as a single argument.
describe "$1" "$2"
describe "$3" "$4"
