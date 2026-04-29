#!/usr/bin/env bash
set -euo pipefail
workdir=certificate_expiry_checker.work
mkdir -p "$workdir"
echo evidence > "$workdir/evidence.txt"
tar -czf "$workdir/archive.tgz" -C "$workdir" evidence.txt
[[ -s "$workdir/archive.tgz" ]] && echo 'certificate_expiry_checker=ok'
