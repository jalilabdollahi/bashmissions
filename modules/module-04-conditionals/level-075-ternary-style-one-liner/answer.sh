#!/usr/bin/env bash
set -euo pipefail

[[ ${1:-} == "ok" ]] && echo "pass" || echo "fail"
