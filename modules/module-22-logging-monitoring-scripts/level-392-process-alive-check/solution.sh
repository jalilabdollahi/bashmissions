#!/usr/bin/env bash
set -euo pipefail
echo $$ > app.pid
pid=$(< app.pid)
kill -0 "$pid" 2>/dev/null && echo 'alive=yes'
