#!/usr/bin/env bash
set -euo pipefail

read -r -p "Name: " name < "$1"
echo "Name is: $name"
