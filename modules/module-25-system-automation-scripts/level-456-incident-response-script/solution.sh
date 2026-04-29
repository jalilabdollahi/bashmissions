#!/usr/bin/env bash
set -euo pipefail
workdir=incident_response_script.work
mkdir -p "$workdir"
echo evidence > "$workdir/evidence.txt"
tar -czf "$workdir/archive.tgz" -C "$workdir" evidence.txt
[[ -s "$workdir/archive.tgz" ]] && echo 'incident_response_script=ok'
