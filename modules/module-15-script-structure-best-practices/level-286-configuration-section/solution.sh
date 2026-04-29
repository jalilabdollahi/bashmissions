#!/usr/bin/env bash
set -euo pipefail

readonly APP_ENV="dev"
readonly RETRIES=3

printf 'env=%s\n' "$APP_ENV"
printf 'retries=%s\n' "$RETRIES"
