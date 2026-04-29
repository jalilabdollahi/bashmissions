#!/usr/bin/env bash
set -euo pipefail

inner() {
  printf 'stack=%s>%s\n' "${FUNCNAME[0]}" "${FUNCNAME[1]}"
}
outer() {
  inner
}
outer
