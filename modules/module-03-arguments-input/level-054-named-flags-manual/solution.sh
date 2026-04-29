#!/usr/bin/env bash
set -euo pipefail

name="unknown"
count="0"

while (( $# > 0 )); do
  case "$1" in
    --name)
      name="$2"
      shift 2
      ;;
    --count)
      count="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

printf 'name=%s count=%s
' "$name" "$count"
