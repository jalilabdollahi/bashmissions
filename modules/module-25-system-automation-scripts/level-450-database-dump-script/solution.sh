#!/usr/bin/env bash
set -euo pipefail
workdir=database_dump_script.work
mkdir -p "$workdir"
echo evidence > "$workdir/evidence.txt"
tar -czf "$workdir/archive.tgz" -C "$workdir" evidence.txt
[[ -s "$workdir/archive.tgz" ]] && echo 'database_dump_script=ok'
