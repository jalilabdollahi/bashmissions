#!/usr/bin/env bash
# App settings resolver. Each setting is decided once, in one line.

name=${APP_NAME:-lanternfish-web}
mode=${APP_MODE:-production}
workers=${APP_WORKERS:-2}

# Fallbacks can be nested: try APP_PORT, then PORT, then the constant.
port=${APP_PORT:-${PORT:-8080}}

cat <<EOF
name=$name
mode=$mode
port=$port
workers=$workers
listen=$name:$port
EOF
