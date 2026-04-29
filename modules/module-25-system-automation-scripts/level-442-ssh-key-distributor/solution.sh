#!/usr/bin/env bash
set -euo pipefail
workdir=ssh_key_distributor.work
mkdir -p "$workdir"
echo evidence > "$workdir/evidence.txt"
tar -czf "$workdir/archive.tgz" -C "$workdir" evidence.txt
[[ -s "$workdir/archive.tgz" ]] && echo 'ssh_key_distributor=ok'
