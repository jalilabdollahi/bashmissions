#!/usr/bin/env bash
set -euo pipefail

mapfile -t names < <(printf '%s\n' alpha beta gamma)
printf '%s\n' "${names[@]}"
