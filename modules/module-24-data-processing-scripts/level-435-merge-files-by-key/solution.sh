#!/usr/bin/env bash
set -euo pipefail
join -t, fixtures/a.csv fixtures/b.csv | join -t, - fixtures/c.csv
