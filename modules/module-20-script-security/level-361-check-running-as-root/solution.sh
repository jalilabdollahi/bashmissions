#!/usr/bin/env bash
set -euo pipefail
if (( EUID == 0 )); then echo 'root=yes'; else echo 'root=no'; fi
