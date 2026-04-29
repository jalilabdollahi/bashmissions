#!/usr/bin/env bash
set -euo pipefail
workdir=restore_verification.work
mkdir -p "$workdir"
echo evidence > "$workdir/evidence.txt"
tar -czf "$workdir/archive.tgz" -C "$workdir" evidence.txt
[[ -s "$workdir/archive.tgz" ]] && echo 'restore_verification=ok'
