#!/usr/bin/env bash
set -euo pipefail
workdir=log_archiver.work
mkdir -p "$workdir"
echo evidence > "$workdir/evidence.txt"
tar -czf "$workdir/archive.tgz" -C "$workdir" evidence.txt
[[ -s "$workdir/archive.tgz" ]] && echo 'log_archiver=ok'
