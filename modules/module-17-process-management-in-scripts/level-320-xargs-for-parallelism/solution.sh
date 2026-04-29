#!/usr/bin/env bash
set -euo pipefail

printf '%s\n' a b c | xargs -n1 -P2 -I{} bash -c 'echo item=$1' _ {} | sort
