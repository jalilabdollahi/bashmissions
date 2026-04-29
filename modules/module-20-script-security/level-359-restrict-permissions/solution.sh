#!/usr/bin/env bash
set -euo pipefail
umask 077
: > secret.txt
echo "perm=$(stat -c '%a' secret.txt)"
