#!/usr/bin/env bash
set -euo pipefail

deploy(){ echo "deploy=$1"; }
func=deploy
"$func" api
