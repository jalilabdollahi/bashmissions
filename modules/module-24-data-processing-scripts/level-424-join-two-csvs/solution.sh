#!/usr/bin/env bash
set -euo pipefail
join -t, -1 1 -2 1 <(sort fixtures/users.csv) <(sort fixtures/roles.csv) | awk -F, '{print $2 "=" $3}'
