#!/usr/bin/env bash
set -euo pipefail
workdir=incremental_backup.work
mkdir -p "$workdir"
echo evidence > "$workdir/evidence.txt"
tar -czf "$workdir/archive.tgz" -C "$workdir" evidence.txt
[[ -s "$workdir/archive.tgz" ]] && echo 'incremental_backup=ok'
