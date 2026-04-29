#!/usr/bin/env bash
set -euo pipefail
awk '$1 >= "10:00" && $1 <= "10:30" {print $2}' fixtures/events.log
