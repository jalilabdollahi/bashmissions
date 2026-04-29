#!/usr/bin/env bash
set -euo pipefail
comm -3 <(sort fixtures/a.txt) <(sort fixtures/b.txt) | sed 's/^\t/right=/; s/^/left=/'
