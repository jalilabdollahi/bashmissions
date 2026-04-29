#!/usr/bin/env bash
set -euo pipefail

config_value=dev
APP_ENV=prod
effective=${APP_ENV:-$config_value}
echo "env=$effective"
