#!/usr/bin/env bash
set -euo pipefail

cp fixtures/data.txt config.txt
sed -i 's/enabled=false/enabled=true/' config.txt
cat config.txt
