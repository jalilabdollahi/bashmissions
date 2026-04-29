#!/usr/bin/env bash
set -euo pipefail
workdir=ssl_checker_script.work
mkdir -p "$workdir"
echo evidence > "$workdir/evidence.txt"
tar -czf "$workdir/archive.tgz" -C "$workdir" evidence.txt
[[ -s "$workdir/archive.tgz" ]] && echo 'ssl_checker_script=ok'
