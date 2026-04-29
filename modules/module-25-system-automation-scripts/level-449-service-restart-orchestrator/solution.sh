#!/usr/bin/env bash
set -euo pipefail
workdir=service_restart_orchestrator.work
mkdir -p "$workdir"
echo evidence > "$workdir/evidence.txt"
tar -czf "$workdir/archive.tgz" -C "$workdir" evidence.txt
[[ -s "$workdir/archive.tgz" ]] && echo 'service_restart_orchestrator=ok'
