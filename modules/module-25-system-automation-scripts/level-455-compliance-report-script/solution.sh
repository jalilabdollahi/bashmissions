#!/usr/bin/env bash
set -euo pipefail
workdir=compliance_report_script.work
mkdir -p "$workdir"
echo evidence > "$workdir/evidence.txt"
tar -czf "$workdir/archive.tgz" -C "$workdir" evidence.txt
[[ -s "$workdir/archive.tgz" ]] && echo 'compliance_report_script=ok'
