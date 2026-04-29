#!/usr/bin/env bash
set -euo pipefail

{
  echo alpha
  echo beta
} > grouped.txt
cat grouped.txt
