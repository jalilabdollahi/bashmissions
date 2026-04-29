#!/usr/bin/env bash
set -euo pipefail

a="false"
b="none"

while getopts "ab:" opt; do
  case "$opt" in
    a) a="true" ;;
    b) b="$OPTARG" ;;
  esac
done

printf 'a=%s b=%s
' "$a" "$b"
