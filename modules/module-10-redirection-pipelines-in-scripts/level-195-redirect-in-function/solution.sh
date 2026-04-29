#!/usr/bin/env bash
set -euo pipefail

write_report() {
  echo "report:start"
  echo "report:done"
}

write_report > report.log
cat report.log
