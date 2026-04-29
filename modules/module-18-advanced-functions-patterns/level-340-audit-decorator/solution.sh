#!/usr/bin/env bash
set -euo pipefail

deploy(){ echo "deploy=$1"; }
audit(){ local func=$1; shift; echo "$func $*" >> audit.log; "$func" "$@"; }
audit deploy api
cat audit.log
