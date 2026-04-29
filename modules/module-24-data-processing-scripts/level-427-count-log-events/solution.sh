#!/usr/bin/env bash
set -euo pipefail
awk '{print $2}' fixtures/app.log | sort | uniq -c | awk '{print $2 "=" $1}' | sort
