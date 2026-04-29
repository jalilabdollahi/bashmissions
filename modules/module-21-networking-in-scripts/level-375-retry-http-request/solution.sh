#!/usr/bin/env bash
set -euo pipefail
attempt=0
while true; do ((++attempt)); if (( attempt == 3 )); then echo "success_on=$attempt"; break; fi; echo "retry=$attempt"; done
