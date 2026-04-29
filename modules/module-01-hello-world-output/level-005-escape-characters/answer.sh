#!/usr/bin/env bash
set -euo pipefail

# Print: File: C:\tmp\report.txt | Quote: "done"
printf 'File: C:\\tmp\\%s | Quote: "%s"\n' "$1" "$2"
