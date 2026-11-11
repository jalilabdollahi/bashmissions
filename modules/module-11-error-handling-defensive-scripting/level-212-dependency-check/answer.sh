#!/usr/bin/env bash
set -euo pipefail

if (( $# == 0 )); then
  echo "usage: solution.sh TOOL..." >&2
  exit 2
fi

missing=()                                   # an array collects every offender
for tool in "$@"; do
  if ! command -v "$tool" > /dev/null 2>&1; then
    missing+=("$tool")
  fi
done

if (( ${#missing[@]} > 0 )); then
  echo "missing: ${missing[*]}" >&2            # [*] joins the elements with spaces
  exit 1
fi
echo "all $# tools found"
