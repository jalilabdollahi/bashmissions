#!/usr/bin/env bash
set -euo pipefail

name=$1

# Two slashes after the variable name = replace EVERY match.
name=${name// /_}

# A slash is also the separator of the expansion, so the one we search for is
# escaped with a backslash: "\/".
name=${name//\//-}

echo "$name"
