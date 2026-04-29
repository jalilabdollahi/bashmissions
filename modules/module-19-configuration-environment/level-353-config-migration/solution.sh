#!/usr/bin/env bash
set -euo pipefail

cp fixtures/old.conf app.conf
sed -i 's/^url=/endpoint=/' app.conf
cat app.conf
