#!/usr/bin/env bash
set -euo pipefail

words=(zero one two three four)
printf '%s\n' "${words[@]:1:3}"
