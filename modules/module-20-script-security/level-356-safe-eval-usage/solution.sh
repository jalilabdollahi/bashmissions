#!/usr/bin/env bash
set -euo pipefail
input='list; touch hacked'
case "$input" in list) echo list ;; status) echo status ;; *) echo 'rejected=unsafe' ;; esac
printf 'hacked=%s\n' "$([[ -e hacked ]] && echo yes || echo no)"
