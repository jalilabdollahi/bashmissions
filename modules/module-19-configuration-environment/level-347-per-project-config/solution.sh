#!/usr/bin/env bash
set -euo pipefail

mkdir -p project/sub/dir
echo "project=demo" > project/.app.conf
cd project/sub/dir
current=$PWD
while [[ $current != / ]]; do
  if [[ -f $current/.app.conf ]]; then cat "$current/.app.conf"; break; fi
  current=${current%/*}
done
