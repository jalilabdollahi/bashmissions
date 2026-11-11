#!/usr/bin/env bash
set -euo pipefail

# Positional parameters are numbered in the order they were typed.
customer=$1
plan=$2
seats=$3

echo "$customer -> $seats seats on the $plan plan"
