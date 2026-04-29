#!/usr/bin/env bash
set -euo pipefail

awk '$3 > 100 {print $1}' fixtures/data.txt
