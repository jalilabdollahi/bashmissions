#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: solution.sh EMAIL PLAN" >&2
  exit 2
fi
email=$1
plan=$2

# -d puts the string in the request body and turns the request into a POST.
reply=$(curl -s -d "email=$email&plan=$plan" https://billing.lanternfish.example/signup)

printf 'reply: %s\n' "$reply"
