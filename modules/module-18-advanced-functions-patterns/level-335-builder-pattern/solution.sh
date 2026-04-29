#!/usr/bin/env bash
set -euo pipefail

declare -A config
set_host(){ config[host]=$1; }
set_port(){ config[port]=$1; }
set_host localhost
set_port 8080
echo "host=${config[host]}"
echo "port=${config[port]}"
