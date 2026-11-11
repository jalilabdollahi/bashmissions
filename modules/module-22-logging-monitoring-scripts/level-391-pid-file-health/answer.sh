#!/usr/bin/env bash
# Detect stale PID files, including PIDs recycled by the kernel.
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: solution.sh PIDFILE NAME" >&2
  exit 2
fi
pidfile=$1
name=$2

if [[ ! -e $pidfile ]]; then
  echo "stopped"
  exit 3
fi

pid=$(< "$pidfile")
if [[ ! $pid =~ ^[0-9]+$ ]]; then
  echo "bad pid file"
  exit 2
fi

# ps exits non-zero for an unknown pid; "|| true" keeps set -e from stopping us
# so that we can report it ourselves.
actual=$(ps -p "$pid" -o comm= || true)

if [[ -z $actual ]]; then
  echo "stale: pid $pid is not running"
  rm -f "$pidfile"
  exit 1
fi

if [[ $actual != "$name" ]]; then
  echo "stale: pid $pid belongs to $actual, not $name"
  rm -f "$pidfile"
  exit 1
fi

echo "running pid=$pid"
