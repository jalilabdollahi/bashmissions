#!/usr/bin/env bash
set -euo pipefail

echo "mode=old" > app.conf
cp app.conf app.conf.bak
echo "mode=new" > app.conf
echo "current=$(cat app.conf)"
echo "backup=$(cat app.conf.bak)"
